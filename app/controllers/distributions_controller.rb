class DistributionsController < ApplicationController
  before_action :set_distribution, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # POST /distributions
  def create
    @distribution = Distribution.new(distribution_params)

    if @distribution.save
      redirect_to @distribution, success: 'Distribution was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /distributions/1
  def update
    if @distribution.update(distribution_params)
      redirect_to @distribution, success: 'Distribution was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /distributions/1
  def destroy
    @distribution.destroy
    redirect_to distributions_url, success: 'Distribution was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution
      @distribution = Distribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_params
      params.require(:distribution).permit(:name)
    end
end
