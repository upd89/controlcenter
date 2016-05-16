class PackageGroupsController < ApplicationController
  before_action :set_package_group, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # POST /package_groups
  def create
    @package_group = PackageGroup.new(package_group_params)

    if @package_group.save
      redirect_to @package_group, success: 'Package group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /package_groups/1
  def update
    if @package_group.update(package_group_params)
      redirect_to @package_group, success: 'Package group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /package_groups/1
  def destroy
    if @package_group.destroy
      redirect_to package_groups_url, success: 'Package group was successfully destroyed.'
    else
      redirect_to system_groups_url, warning: 'Can\'t delete a group that\'s not empty.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package_group
      @package_group = PackageGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_group_params
      params.require(:package_group).permit(:name, :permission_level)
    end
end
