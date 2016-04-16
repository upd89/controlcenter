class SystemUpdatesController < ApplicationController
  before_action :set_system_update, only: [:show, :edit, :update, :destroy]

  # GET /system_updates
  # GET /system_updates.json
  def index
    @system_updates = SystemUpdate.all
    @paginated_system_updates = @system_updates.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /system_updates/1
  # GET /system_updates/1.json
  def show
  end

  # GET /system_updates/new
  def new
    @system_update = SystemUpdate.new
  end

  # GET /system_updates/1/edit
  def edit
  end

  # POST /system_updates
  # POST /system_updates.json
  def create
    @system_update = SystemUpdate.new(system_update_params)

    respond_to do |format|
      if @system_update.save
        format.html { redirect_to @system_update, notice: 'System update was successfully created.' }
        format.json { render :show, status: :created, location: @system_update }
      else
        format.html { render :new }
        format.json { render json: @system_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_updates/1
  # PATCH/PUT /system_updates/1.json
  def update
    respond_to do |format|
      if @system_update.update(system_update_params)
        format.html { redirect_to @system_update, notice: 'System update was successfully updated.' }
        format.json { render :show, status: :ok, location: @system_update }
      else
        format.html { render :edit }
        format.json { render json: @system_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_updates/1
  # DELETE /system_updates/1.json
  def destroy
    @system_update.destroy
    respond_to do |format|
      format.html { redirect_to system_updates_url, notice: 'System update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_update
      @system_update = SystemUpdate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_update_params
      params.require(:system_update).permit(:system_update_state_id, :package_update_id, :system_id, :task_id)
    end
end
