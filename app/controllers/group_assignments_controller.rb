class GroupAssignmentsController < ApplicationController
  before_action :set_group_assignment, only: [:show, :edit, :update, :destroy]

  # GET /group_assignments
  # GET /group_assignments.json
  def index
    @group_assignments = GroupAssignment.all
  end

  # GET /group_assignments/1
  # GET /group_assignments/1.json
  def show
  end

  # GET /group_assignments/new
  def new
    @group_assignment = GroupAssignment.new
  end

  # GET /group_assignments/1/edit
  def edit
  end

  # POST /group_assignments
  # POST /group_assignments.json
  def create
    @group_assignment = GroupAssignment.new(group_assignment_params)

    respond_to do |format|
      if @group_assignment.save
        format.html { redirect_to @group_assignment, success: 'Group assignment was successfully created.' }
        format.json { render :show, status: :created, location: @group_assignment }
      else
        format.html { render :new }
        format.json { render json: @group_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_assignments/1
  # PATCH/PUT /group_assignments/1.json
  def update
    respond_to do |format|
      if @group_assignment.update(group_assignment_params)
        format.html { redirect_to @group_assignment, success: 'Group assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_assignment }
      else
        format.html { render :edit }
        format.json { render json: @group_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_assignments/1
  # DELETE /group_assignments/1.json
  def destroy
    @group_assignment.destroy
    respond_to do |format|
      format.html { redirect_to group_assignments_url, success: 'Group assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_assignment
      @group_assignment = GroupAssignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_assignment_params
      params.require(:group_assignment).permit(:package_group_id, :package_id)
    end
end
