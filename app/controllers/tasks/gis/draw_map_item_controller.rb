class Tasks::Gis::DrawMapItemController < ApplicationController
  before_action :disable_turbolinks, only: [:new_map_item, :collect_item]

  def new_map_item
    # @asserted_distribution = AssertedDistributions.new(asserted_distribution_params)
    # @otu                = Otu.find(params[:asserted_distribution][:otu_id])
    # todo: this needs to be tested and accounted for in maps.js
    @feature_collection = ::Gis::GeoJSON.feature_collection([])
    # source_id           = params[:asserted_distribution][:source_id]
    # @source             = Source.find(source_id) unless source_id.blank?
  end

  def create_map_item
  end

  def collect_item

    geographic_areas = GeographicArea.find_by_lat_long(
        params['latitude'].to_f,
        params['longitude'].to_f
    )

    @feature_collection     = ::Gis::GeoJSON.feature_collection(geographic_areas)
    # @asserted_distributions = AssertedDistribution.stub_new(collection_params(params).merge('geographic_areas' => geographic_areas))

    # render json: {
    #            html:               render_to_string(partial:    'asserted_distributions/quick_new_asserted_distribution_form',
    #                                                 collection: @asserted_distributions,
    #                                                 as:         :asserted_distribution,
    #                                                 locals:     {token: form_authenticity_token}),
    #            feature_collection: @feature_collection,
    #        }
  end

  # protected

  # def collection_params(params)
  #   params.require(:asserted_distribution).permit(:source_id, :otu_id)
  # end
end
