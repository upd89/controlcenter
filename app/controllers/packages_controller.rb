class PackagesController < ApplicationController
  before_action :set_package, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /packages
  def index
    @filterrific = initialize_filterrific(
      Package,
      params[:filterrific],
      :select_options => {
        sorted_by: Package.options_for_sorted_by,
        with_package_group_id: PackageGroup.options_for_select
      }
    ) or return
    @packages = @filterrific.find.page(params[:page])
  end

  # GET /packages/1
  def show
    @package_versions = PackageVersion.where(:package => @package)
    @paginated_package_versions = @package_versions.paginate(:page => params[:page], :per_page => Settings.Pagination.NoOfEntriesPerPage)
  end

  # POST /packages
  def create
    @package = Package.new(package_params)

    if @package.save
      redirect_to @package, success: 'Package was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /packages/1
  def update
    if @package.update(package_params)
      redirect_to @package, success: 'Package was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /packages/1
  def destroy
    @package.destroy
    redirect_to packages_url, success: 'Package was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.require(:package).permit(:name, :base_version, :architecture, :section, :repository, :homepage, :summary)
    end
end
