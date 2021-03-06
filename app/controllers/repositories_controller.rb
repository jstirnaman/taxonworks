class RepositoriesController < ApplicationController
  include DataControllerConfiguration::SharedDataControllerConfiguration

  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories   = Repository.limit(20)
    @recent_objects = Repository.order(updated_at: :desc).limit(10)
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(repository_params)

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render action: 'show', status: :created, location: @repository }
      else
        format.html { render action: 'new' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end

  def list
    @repositories = Repository.order(:id).page(params[:page]) #.per(10) #.per(3)
  end

  def search
    if params[:id]
      redirect_to respository_path(params[:id])
    else
      redirect_to respositories_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    end
  end

  def autocomplete
    @repositories = Repository.find_for_autocomplete(params)

    data = @repositories.collect do |t|
      {id:              t.id,
       label:           RepositoriesHelper.repository_tag(t),
       response_values: {
         params[:method] => t.id
       },
       label_html:      RepositoriesHelper.repository_tag(t)
      }
    end

    render :json => data

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def repository_params
    params.require(:repository).permit(:name, :url, :acronym, :status, :institutional_LSID, :is_index_herbarioum_record, :created_by_id, :updated_by_id)
  end
end
