class PackageGroupsController < ApplicationController
  before_action :set_package_group, only: [:show, :edit, :update, :destroy]

  # GET /package_groups
  # GET /package_groups.json
  def index
    @package_groups = PackageGroup.all
  end

  # GET /package_groups/1
  # GET /package_groups/1.json
  def show
  end

  # GET /package_groups/new
  def new
    @package_group = PackageGroup.new
  end

  # GET /package_groups/1/edit
  def edit
  end

  # POST /package_groups
  # POST /package_groups.json
  def create
    @package_group = PackageGroup.new(package_group_params)

    respond_to do |format|
      if @package_group.save
        format.html { redirect_to @package_group, success: 'Package group was successfully created.' }
        format.json { render :show, status: :created, location: @package_group }
      else
        format.html { render :new }
        format.json { render json: @package_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /package_groups/1
  # PATCH/PUT /package_groups/1.json
  def update
    respond_to do |format|
      if @package_group.update(package_group_params)
        format.html { redirect_to @package_group, success: 'Package group was successfully updated.' }
        format.json { render :show, status: :ok, location: @package_group }
      else
        format.html { render :edit }
        format.json { render json: @package_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /package_groups/1
  # DELETE /package_groups/1.json
  def destroy
    @package_group.destroy
    respond_to do |format|
      format.html { redirect_to package_groups_url, success: 'Package group was successfully destroyed.' }
      format.json { head :no_content }
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
