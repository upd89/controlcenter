class SystemGroupsController < ApplicationController
  before_action :set_system_group, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /system_groups/1
  def show
    @systems = System.where(:system_group => @system_group)
    @paginated_systems = @systems.paginate(:page => params[:page], :per_page => Settings.Pagination.NoOfEntriesPerPage)
  end

  # POST /system_groups
  def create
    @system_group = SystemGroup.new(system_group_params)

    if @system_group.save
      redirect_to @system_group, success: 'System group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /system_groups/1
  def update
    if @system_group.update(system_group_params)
      redirect_to @system_group, success: 'System group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /system_groups/1
  def destroy
    if @system_group.destroy
      redirect_to system_groups_url, success: 'System group was successfully destroyed.'
    else
      redirect_to system_groups_url, warning: 'Can\'t delete a group that\'s not empty.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_group
      @system_group = SystemGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_group_params
      params.require(:system_group).permit(:name, :permission_level)
    end
end
