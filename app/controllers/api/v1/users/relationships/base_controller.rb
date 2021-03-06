class API::V1::Users::Relationships::BaseController < API::V1::APIController
  before_action :set_target_user

  private

  def set_target_user
    @target_user = User.find_by(id: params[:id])
    head :not_found and return unless @target_user
  end
end
