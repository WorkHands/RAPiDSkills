class API::V1::UsersController < API::V1::APIController
  skip_before_action :authenticate, only: :create
  before_action :set_target_user, only: [:show, :update]

  ## TODO remove support for leads overriding generated passwords once the site 
  ## is opened up to anyone.
  def create
    existing_user = User.find_for_database_authentication(email: user_params[:email])
    if existing_user&.joined? || existing_user.nil? 
      @user = User.new ## Default behavior
    else 
      @user = existing_user ## Lead that hasnt created their own password
    end
    @user.assign_attributes(user_params)
    @user.employer = define_employer
    @user.role = :basic unless @user.admin?
    if @user.save
      @session = @user.create_session!
      sign_in @user
      render json: API::V1::UserSerializer.new(@user, render_options), status: :created
    else
      render_resource_error(@user)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def show
    @user = authorize([:api, :v1, @target_user])[2]
    render json: API::V1::UserSerializer.new(@user, render_options)
  end

  def update
    @user = authorize([:api, :v1, @target_user])[2]
    @user.assign_attributes(user_params)
    @user.employer = define_employer
    if @user.save
      render json: API::V1::UserSerializer.new(@user, render_options)
    else
      render_resource_error(@user)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  private

  def set_target_user
    @target_user = User.find_by(id: params[:id])
    head :not_found and return unless @target_user
  end

  def user_params
    params.require(:data).require(:attributes).permit(:name, :email, :settings, :password)
  end

  def organization_params
    params.require(:data).require(:attributes).permit(:organization_title)
  end

  def define_employer
    Organization.where(
      title: organization_params[:organization_title]
    ).first_or_initialize
  end

  def render_options
    options = { include: include_options }
    options[:meta] = { access_token: @session.token , token_type: "Bearer" } if @session
    options
  end

  def include_options
    options = []
    options += [:employer] if @user.employer&.persisted?
    options += [:client_sessions] if @session
  end
end
