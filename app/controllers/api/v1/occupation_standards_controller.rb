class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_occupation_standard, only: [:show, :update, :destroy]
  after_action :generate_download_docs, only: [:create, :update], if: -> { response.successful? }

  def index
    @oss = OccupationStandard.with_eager_loading.search_records(search_params.to_h)
    options = API::V1::PaginationLinkGenerator.new(
      request: request,
      query_params: query_params,
      total_pages: @oss.total_pages,
    ).call()
    render_resource(@oss, options)
  end

  def show
    options = { links: { self: request.original_url } }
    options[:include] = include_relationships
    render_resource(@os, options)
  end

  def create
    parent = OccupationStandard.find_by(id: create_params[:parent_occupation_standard_id])
    if parent
      @os = parent.clone_as_unregistered!(
        creator_id: current_user.id,
        organization_id: current_user.employer_id,
        new_title: create_params[:title],
      )
      options = { include: include_relationships }
      @os.valid? ? render_resource(@os, options) : render_resource_error(@os)
    else
      @os = OccupationStandard.new
      @os.errors.add(:parent_occupation_standard_id, :invalid)
      render_resource_error(@os)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def update
    authorize @os, policy_class: API::V1::OccupationStandardPolicy

    if organization_params[:organization_title].present?
      @os.organization = Organization.where(
        title: organization_params[:organization_title]
      ).first_or_initialize
    end

    if @os.update(update_params)
      options = { links: { self: request.original_url } }
      options[:include] = include_relationships
      render_resource(@os, options)
    else
      render_resource_error(@os)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def destroy
    authorize @os, policy_class: API::V1::OccupationStandardPolicy
    @os.destroy
    head :no_content
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:id])
    head :not_found and return unless @os
  end

  def search_params
    params.permit(:q, :occupation_id, :organization_id, :creator, page: [:number, :size])
  end

  def create_params
    params.require(:data).require(:attributes).permit(:parent_occupation_standard_id, :title)
  end

  def update_params
    relationships_params = params.require(:data).permit(relationships: { occupation: {}, registration_state: {} })
    relationships_params = relationships_params[:relationships] || {}

    relationships = {}
    relationships_params.each do |key, data_hash|
      relationships["#{key}_id"] = data_hash["data"]["id"]
    end
    params.require(:data).fetch(:attributes, {}).permit(:title, :registration_organization_name).merge(relationships)
  end

  def organization_params
    params.require(:data).fetch(:attributes, {}).permit(:organization_title)
  end

  def query_params
    params.permit(:q, :occupation_id, :organization_id, :creator, page: {})
  end

  def include_relationships
    [
      :creator,
      :occupation,
      :organization,
      :parent_occupation_standard,
      :registration_state,
      :occupation_standard_skills,
      :"occupation_standard_work_processes.occupation_standard_skills",
      :"occupation_standard_work_processes.categories.occupation_standard_skills",
    ]
  end

  def render_resource(record, options={})
    render json: API::V1::OccupationStandardSerializer.new(record, options)
  end

  def generate_download_docs
    @os.generate_download_docs
  end
end
