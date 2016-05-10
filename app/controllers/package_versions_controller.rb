class PackageVersionsController < ApplicationController
  before_action :set_package_version, only: [:show, :edit, :update, :destroy]

  # GET /package_versions
  # GET /package_versions.json
  def index
    @package_versions = PackageVersion.all
  end

  # GET /package_versions/1
  # GET /package_versions/1.json
  def show
  end

  # GET /package_versions/new
  def new
    @package_version = PackageVersion.new
  end

  # GET /package_versions/1/edit
  def edit
  end

  # POST /package_versions
  # POST /package_versions.json
  def create
    @package_version = PackageVersion.new(package_version_params)

    respond_to do |format|
      if @package_version.save
        format.html { redirect_to @package_version, success: 'Package version was successfully created.' }
        format.json { render :show, status: :created, location: @package_version }
      else
        format.html { render :new }
        format.json { render json: @package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /package_versions/1
  # PATCH/PUT /package_versions/1.json
  def update
    respond_to do |format|
      if @package_version.update(package_version_params)
        format.html { redirect_to @package_version, success: 'Package version was successfully updated.' }
        format.json { render :show, status: :ok, location: @package_version }
      else
        format.html { render :edit }
        format.json { render json: @package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /package_versions/1
  # DELETE /package_versions/1.json
  def destroy
    @package_version.destroy
    respond_to do |format|
      format.html { redirect_to package_versions_url, success: 'Package version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package_version
      @package_version = PackageVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_version_params
      params.require(:package_version).permit(:sha256, :version, :architecture, :package_id, :distribution_id, :repository_id, :is_base_version)
    end
end
