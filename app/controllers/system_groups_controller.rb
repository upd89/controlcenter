class SystemGroupsController < ApplicationController
  before_action :set_system_group, only: [:show, :edit, :update, :destroy]

  # GET /system_groups
  # GET /system_groups.json
  def index
    @system_groups = SystemGroup.all
  end

  # GET /system_groups/1
  # GET /system_groups/1.json
  def show
    @systems = System.where(:system_group => @system_group)
    @paginated_systems = @systems.paginate(:page => params[:page], :per_page => Settings.Pagination.NoOfEntriesPerPage)
  end

  # GET /system_groups/new
  def new
    @system_group = SystemGroup.new
  end

  # GET /system_groups/1/edit
  def edit
  end

  # POST /system_groups
  # POST /system_groups.json
  def create
    @system_group = SystemGroup.new(system_group_params)

    respond_to do |format|
      if @system_group.save
        format.html { redirect_to @system_group, success: 'System group was successfully created.' }
        format.json { render :show, status: :created, location: @system_group }
      else
        format.html { render :new }
        format.json { render json: @system_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_groups/1
  # PATCH/PUT /system_groups/1.json
  def update
    respond_to do |format|
      if @system_group.update(system_group_params)
        format.html { redirect_to @system_group, success: 'System group was successfully updated.' }
        format.json { render :show, status: :ok, location: @system_group }
      else
        format.html { render :edit }
        format.json { render json: @system_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_groups/1
  # DELETE /system_groups/1.json
  def destroy
    if @system_group.destroy
      respond_to do |format|
        format.html { redirect_to system_groups_url, success: 'System group was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to system_groups_url, warning: 'Can\'t delete a group that\'s not empty.' }
      end
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
