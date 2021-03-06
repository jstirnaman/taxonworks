class ContainerItemsController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_container_item, only: [:update, :destroy]

  # POST /container_items
  # POST /container_items.json
  def create
    @container_item = ContainerItem.new(container_item_params)

    respond_to do |format|
      if @container_item.save
        format.html { redirect_to :back, notice: 'Container item was successfully created.' }
        format.json { render json: @container_item, status: :created, location: @container_item }
      else
        format.html { redirect_to :back, notice: 'Container item was NOT successfully created.' }
        format.json { render json: @container_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /container_items/1
  # PATCH/PUT /container_items/1.json
  def update
    respond_to do |format|
      if @container_item.update(container_item_params)
        format.html { redirect_to :back, notice: 'Container item was successfully updated.' }
        format.json { render json: @container_item, status: :ok, location: @container_item }
      else
        format.html { redirect_to :back, notice: 'Container item was NOT successfully updated.' }
        format.json { render json: @container_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /container_items/1
  # DELETE /container_items/1.json
  def destroy
    @container_item.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Container item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_container_item
      @container_item = ContainerItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def container_item_params
      params.require(:container_item).permit(:container_id, :position, :contained_object_id, :contained_object_type, :localization, :created_by_id, :updated_by_id, :project_id)
    end
end
