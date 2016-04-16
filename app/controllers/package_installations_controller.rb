class PackageInstallationsController < ApplicationController
  before_action :set_package_installation, only: [:show, :edit, :update, :destroy]

  # GET /package_installations
  # GET /package_installations.json
  def index
    @package_installations = PackageInstallation.all.includes(:system, :package)
    @paginated_package_installations = @package_installations.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /package_installations/1
  # GET /package_installations/1.json
  def show
  end

  # GET /package_installations/new
  def new
    @package_installation = PackageInstallation.new
  end

  # GET /package_installations/1/edit
  def edit
  end

  # POST /package_installations
  # POST /package_installations.json
  def create
    @package_installation = PackageInstallation.new(package_installation_params)

    respond_to do |format|
      if @package_installation.save
        format.html { redirect_to @package_installation, notice: 'Package installation was successfully created.' }
        format.json { render :show, status: :created, location: @package_installation }
      else
        format.html { render :new }
        format.json { render json: @package_installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /package_installations/1
  # PATCH/PUT /package_installations/1.json
  def update
    respond_to do |format|
      if @package_installation.update(package_installation_params)
        format.html { redirect_to @package_installation, notice: 'Package installation was successfully updated.' }
        format.json { render :show, status: :ok, location: @package_installation }
      else
        format.html { render :edit }
        format.json { render json: @package_installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /package_installations/1
  # DELETE /package_installations/1.json
  def destroy
    @package_installation.destroy
    respond_to do |format|
      format.html { redirect_to package_installations_url, notice: 'Package installation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package_installation
      @package_installation = PackageInstallation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_installation_params
      params.require(:package_installation).permit(:installed_version, :package_id, :system_id)
    end
end
