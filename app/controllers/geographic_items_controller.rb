class GeographicItemsController < ApplicationController
  before_filter :require_sign_in

  before_action :set_geographic_item, only: [:show, :edit, :update, :destroy]

  # GET /geographic_items/1
  # GET /geographic_items/1.json
  def show
  end

  # GET /geographic_items/1/edit
  def edit
  end

  # PATCH/PUT /geographic_items/1
  # PATCH/PUT /geographic_items/1.json
  def update
    respond_to do |format|
      if @geographic_item.update(geographic_item_params)
        format.html { redirect_to @geographic_item.metamorphosize, notice: 'Geographic item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @geographic_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geographic_items/1
  # DELETE /geographic_items/1.json
  def destroy
    @geographic_item.destroy
    respond_to do |format|
      format.html { redirect_to geographic_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geographic_item
      @geographic_item = GeographicItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def geographic_item_params
      params.require(:geographic_item).permit(:point, :line_string, :polygon, :multi_point, :multi_line_string, :multi_polygon, :geometry_collection, :created_by_id, :updated_by_id)
    end
end
