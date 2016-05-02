class ConcretePackageVersionsController < ApplicationController
  before_action :set_concrete_package_version, only: [:show, :edit, :update, :destroy]

  # GET /concrete_package_versions
  # GET /concrete_package_versions.json
  def index
    @concrete_package_versions = ConcretePackageVersion.all
  end

  # GET /concrete_package_versions/1
  # GET /concrete_package_versions/1.json
  def show
  end

  # GET /concrete_package_versions/new
  def new
    @concrete_package_version = ConcretePackageVersion.new
  end

  # GET /concrete_package_versions/1/edit
  def edit
  end

  # POST /concrete_package_versions
  # POST /concrete_package_versions.json
  def create
    @concrete_package_version = ConcretePackageVersion.new(concrete_package_version_params)

    respond_to do |format|
      if @concrete_package_version.save
        format.html { redirect_to @concrete_package_version, notice: 'Concrete package version was successfully created.' }
        format.json { render :show, status: :created, location: @concrete_package_version }
      else
        format.html { render :new }
        format.json { render json: @concrete_package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /concrete_package_versions/1
  # PATCH/PUT /concrete_package_versions/1.json
  def update
    respond_to do |format|
      if @concrete_package_version.update(concrete_package_version_params)
        format.html { redirect_to @concrete_package_version, notice: 'Concrete package version was successfully updated.' }
        format.json { render :show, status: :ok, location: @concrete_package_version }
      else
        format.html { render :edit }
        format.json { render json: @concrete_package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concrete_package_versions/1
  # DELETE /concrete_package_versions/1.json
  def destroy
    @concrete_package_version.destroy
    respond_to do |format|
      format.html { redirect_to concrete_package_versions_url, notice: 'Concrete package version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concrete_package_version
      @concrete_package_version = ConcretePackageVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concrete_package_version_params
      params.require(:concrete_package_version).permit(:system_id, :task_id, :concrete_package_state_id, :package_version_id)
    end
end
