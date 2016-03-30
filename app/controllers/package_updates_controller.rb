class PackageUpdatesController < ApplicationController
  before_action :set_package_update, only: [:show, :edit, :update, :destroy]

  # GET /package_updates
  # GET /package_updates.json
  def index
    @package_updates = PackageUpdate.all
  end

  # GET /package_updates/1
  # GET /package_updates/1.json
  def show
  end

  # GET /package_updates/new
  def new
    @package_update = PackageUpdate.new
  end

  # GET /package_updates/1/edit
  def edit
  end

  # POST /package_updates
  # POST /package_updates.json
  def create
    @package_update = PackageUpdate.new(package_update_params)

    respond_to do |format|
      if @package_update.save
        format.html { redirect_to @package_update, notice: 'Package update was successfully created.' }
        format.json { render :show, status: :created, location: @package_update }
      else
        format.html { render :new }
        format.json { render json: @package_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /package_updates/1
  # PATCH/PUT /package_updates/1.json
  def update
    respond_to do |format|
      if @package_update.update(package_update_params)
        format.html { redirect_to @package_update, notice: 'Package update was successfully updated.' }
        format.json { render :show, status: :ok, location: @package_update }
      else
        format.html { render :edit }
        format.json { render json: @package_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /package_updates/1
  # DELETE /package_updates/1.json
  def destroy
    @package_update.destroy
    respond_to do |format|
      format.html { redirect_to package_updates_url, notice: 'Package update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package_update
      @package_update = PackageUpdate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_update_params
      params.require(:package_update).permit(:candidate_version, :repository, :package_id)
    end
end
