class OtusController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_otu, only: [:show, :edit, :update, :destroy]

  # GET /otus
  # GET /otus.json
  def index
    @recent_objects = Otu.recent_from_project_id($project_id).order(updated_at: :desc).limit(10)
  end

  # GET /otus/1
  # GET /otus/1.json
  def show
  end

  # GET /otus/new
  def new
    @otu = Otu.new
  end

  # GET /otus/1/edit
  def edit
  end

  def list
    @otus = Otu.with_project_id($project_id).order(:id).page(params[:page]) #.per(10) 
  end

  # POST /otus
  # POST /otus.json
  def create
    @otu = Otu.new(otu_params)

    respond_to do |format|
      if @otu.save
        format.html { redirect_to @otu,
                     notice: "Otu '#{@otu.name}' was successfully created." }
        format.json { render action: 'show', status: :created, location: @otu }
      else
        format.html { render action: 'new' }
        format.json { render json: @otu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /otus/1
  # PATCH/PUT /otus/1.json
  def update
    respond_to do |format|
      if @otu.update(otu_params)
        format.html { redirect_to @otu, notice: 'Otu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @otu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /otus/1
  # DELETE /otus/1.json
  def destroy
    @otu.destroy
    respond_to do |format|
      format.html { redirect_to otus_url }
      format.json { head :no_content }
    end
  end

  def search
    if params[:id] 
      redirect_to otu_path(params[:id])
    else
      redirect_to otus_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    end
  end

  def autocomplete
    @otus = Otu.find_for_autocomplete(params.merge(project_id: sessions_current_project_id))
    data = @otus.collect do |t|
      {id: t.id,
       label: OtusHelper.otu_tag(t),
       response_values: {
         params[:method] => t.id
       },
       label_html: OtusHelper.otu_tag(t) #  render_to_string(:partial => 'shared/autocomplete/taxon_name.html', :object => t)
      }
    end

    render :json => data
  end

  def batch_preview
    @otus = Otu.batch_preview(file: params[:file].tempfile)
  end

  def batch_create
    if @otus = Otu.batch_create(params.symbolize_keys.to_h)
      flash[:notice] = "Successfully batch created #{@otus.count} OTUs."
    else
      # TODO: more response
      flash[:notice] = 'Failed to create the Otus.'
    end
    redirect_to otus_path
  end


  # GET /otus/download
  def download
    send_data Otu.generate_download(project_id: $project_id), type: 'text'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_otu
    @otu = Otu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def otu_params
    params.require(:otu).permit(:name, :taxon_name_id)
  end
end
