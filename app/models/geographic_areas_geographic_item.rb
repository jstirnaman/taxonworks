# A GeographicAreaGeographicItem is an assertion that a 
# GeographicArea was defined by a shape (GeographicItem) according to some source. 
# The assertion may be bound by time.
#
# @!attribute geographic_area_id
#   @return [Integer]
#    The id of a GeographicArea that represents the area of this association.
# @!attribute geographic_item_id
#   @return [Integer]
#    The id of a GeographicItem that represents the geography of this association.
# @!attribute data_origin
#   @return [String]
#     The origin of this shape associations, take from SFGs /gaz data
# @!attribute origin_gid 
#   @return [String]
#     The gid (row number) taken from the shape table from the source
# @!attribute date_valid_from
#   @return [String]
#     The verbatim value taken from the source data as to when this shape was first valid for the associated GeographicArea (name)
# @!attribute date_valid_to
#   @return [String]
#     The verbatim data value taken from the source data as to when this shape was last valid for the associated GeographicArea (name)
class GeographicAreasGeographicItem < ActiveRecord::Base
  include Shared::IsData 

  belongs_to :geographic_area, inverse_of: :geographic_areas_geographic_items
  belongs_to :geographic_item, inverse_of: :geographic_areas_geographic_items

  validates :geographic_area, presence: true

  unless ENV['NO_GEO_VALID'] 
    validates :geographic_item, presence: true  
  end
end
