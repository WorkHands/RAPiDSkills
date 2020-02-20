class API::V1::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_occupation_standard, only: [:index]
  before_action :set_occupation_standard_skill, only: [:show, :update]
  before_action :authorize_parent, only: [:create]
  after_action :generate_download_docs, only: [:create, :update], if: -> { response.successful? }

  def index
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = { links: { self: @os.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def show
    render_resource
  end

  def create
    @oss = @os.occupation_standard_skills.build
    save_and_update_skill
  end

  def update
    authorize [:api, :v1, @oss]
    save_and_update_skill
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:occupation_standard_id])
    head :not_found and return unless @os
  end

  def set_occupation_standard_skill
    @oss = OccupationStandardSkill.find_by(id: params[:id])
    head :not_found and return unless @oss
  end

  def authorize_parent
    @os = OccupationStandard.find_by(id: occupation_standard_params[:id])
    @oswp = OccupationStandardWorkProcess.find_by(id: work_process_params[:id])
    head :not_found and return unless @os || @oswp

    if @os
      authorize @os, :create_skill?, policy_class: API::V1::OccupationStandardPolicy
    end

    if @oswp
      authorize [:api, :v1, @oswp], :create_skill?
      @os = @oswp.occupation_standard
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:description)
  end

  def oss_params
    params.require(:data).require(:attributes).permit(:sort_order)
  end

  def save_and_update_skill
    skill = Skill.where(update_params).first_or_initialize(parent_skill: @oss.skill)
    if skill.save
      attributes = {
        skill: skill,
        sort_order: oss_params[:sort_order],
      }
      attributes[:occupation_standard_work_process] = @oswp if @oswp.present?
      @oss.update(attributes)
      render_resource
    else
      render_resource_error(skill)
    end
  end

  def occupation_standard_params
    params.require(:data).require(:relationships).fetch(:occupation_standard, {}).fetch(:data, {}).permit(:id)
  end

  def work_process_params
    params.require(:data).require(:relationships).fetch(:work_process, {}).fetch(:data, {}).permit(:id)
  end

  def render_resource
    options = { links: { self: @oss.url } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@oss, options)
  end

  def generate_download_docs
    @oss.occupation_standard.generate_download_docs
  end
end
