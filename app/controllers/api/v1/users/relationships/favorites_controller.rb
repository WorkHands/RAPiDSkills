class API::V1::Users::Relationships::FavoritesController < API::V1::APIController
  before_action :set_target_user

  def index
    authorize [:api, :v1, @target_user], :favorite?
    @occupation_standards = @target_user.favorites
    options = {
      links: {
        self: @target_user.relationships_url('favorites'),
        related: @target_user.related_url('favorites'),
      }
    }
    render json: API::V1::User::Relationships::OccupationStandardSerializer.new(@occupation_standards, options)
  end

  def create
    authorize [:api, :v1, @target_user], :favorite?
    object_params.each do |object_param|
      os = OccupationStandard.find(object_param[:id])
      Relationship.create(user: @target_user, occupation_standard: os)
    end
    head :ok
  end

  def destroy
    authorize [:api, :v1, @target_user], :favorite?
    object_params.each do |object_param|
      os = OccupationStandard.find(object_param[:id])
      Relationship.where(user: @target_user, occupation_standard: os).destroy_all
    end
    head :ok
  end

  private

  def set_target_user
    @target_user = User.where(id: params[:id]).first_or_initialize
  end

  def object_params
    params.require(:data)
  end
end