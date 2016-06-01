class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # POST /repositories
  def create
    @repository = Repository.new(repository_params)

    if @repository.save
      redirect_to @repository, success: 'Repository was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /repositories/1
  def update
    if @repository.update(repository_params)
      redirect_to @repository, success: 'Repository was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    redirect_to repositories_url, success: 'Repository was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:origin, :archive, :component)
    end
end
