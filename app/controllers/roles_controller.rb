class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /roles/1
  def show
    @users = User.where(role: @role)
    @paginated_users = @users.paginate(page: params[:page], per_page: Settings.Pagination.NoOfEntriesPerPage)
  end

  # POST /roles
  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to @role, success: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      redirect_to @role, success: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /roles/1
  def destroy
    if @role.destroy
      redirect_to roles_url, success: 'Role was successfully destroyed.'
    else
      redirect_to roles_url, warning: 'Can\'t delete role while users use this role'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :permission_level)
    end
end
