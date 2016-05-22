class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  skip_before_action :require_login, only: [:new, :create]

  load_and_authorize_resource

  def show
    @system_groups = SystemGroup.where("permission_level <= ?", @user.role.permission_level )

    @package_groups = PackageGroup.where("permission_level <= ?", @user.role.permission_level )
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, success: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, success: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, success: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id)
    end
end
