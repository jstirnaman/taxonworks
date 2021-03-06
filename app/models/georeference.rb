# A georeference is an assertion that some shape, as derived from some method, describes the location of some collecting event.
# A georeference contains three components:
#    1) A reference to a CollectingEvent (who, where, when, how)
#    2) A reference to a GeographicItem (a shape)
#    3) A method by which the shape was associated with the collecting event (via `type` subclassing).
# If a georeference was published it's Source can be provided.  This is not equivalent to a method.
#
# Contains information about a location on the face of the Earth, consisting of:
#
# @!attribute geographic_item_id
#   @return [Integer]
#     The id of a GeographicItem that represents the (non-error) representation of this georeference definition.
#     Generally, it will represent a point.
# @!attribute collecting_event_id
#   @return [Integer]
#     The id of a CollectingEvent that represents the event of this georeference definition.
# @!attribute error_radius
#   @return [Integer]
#     The distance in meters of the radius of the area of horizontal uncertainty of the accuracy of the location of
#     this georeference definition.
# @!attribute error_depth
#   @return [Integer]
#     The distance in meters of the radius of the area of vertical uncertainty of the accuracy of the location of
#     this georeference definition.
# @!attribute error_geographic_item_id
#   @return [Integer]
#     The id of a GeographicItem that represents the (error) representation of this georeference definition.
#     Generally, it will represent a polygon.
# @!attribute type
#   @return [String]
#     The type name of the this georeference definition.
# @!attribute source_id
#   @return [Integer]
#     When provided, asserts that this data originated in the specified source.
# @!attribute position
#   @return [Integer]
#     An arbitrary ordering mechanism, the first georeference is routinely defaulted to in the application
# @!attribute is_public
#   @return [Boolean]
#     True if this georeference can be shared, otherwise false.
# @!attribute api_request
#   @return [String]
#     The text of the GeoLocation request (::GeoLocate), or the verbatim data (VerbatimData)
# @!attribute is_undefined_z
#   @return [Boolean]
#     True if this georeference cannot be located vertically, otherwise false.
# @!attribute is_median_z
#   @return [Boolean]
#     True if this georeference represents an average vertical distance, otherwise false.
#
class Georeference < ActiveRecord::Base
  include Housekeeping
  include Shared::IsData

  attr_accessor :iframe_response # used to pass the geolocate from Tulane through

  SPHEROID = 'SPHEROID["WGS-84", 6378137, 298.257223563]'
  # This should probably be moved out to config/initializers/gis
  FACTORY  = RGeo::Geographic.projected_factory(srid:                    4326,
                                                projection_srid:         4326,
                                                projection_proj4:        '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs',
                                                uses_lenient_assertions: true,
                                                has_z_coordinate:        true)

  acts_as_list scope: [:collecting_event]

  belongs_to :error_geographic_item, class_name: 'GeographicItem', foreign_key: :error_geographic_item_id
  belongs_to :collecting_event
  belongs_to :geographic_item
  belongs_to :source

  validates :geographic_item, presence: true
  validates :collecting_event, presence: true
  validates :type, presence: true

  # TODone: Break this down into individual validations
  # validate :proper_data_is_provided
  validate :add_error_radius
  validate :add_error_depth
  validate :add_obj_inside_err_geo_item
  validate :add_obj_inside_err_radius
  validate :add_err_geo_item_inside_err_radius
  validate :add_error_radius_inside_area
  validate :add_error_geo_item_inside_area
  validate :add_obj_inside_area

  accepts_nested_attributes_for :geographic_item, :error_geographic_item

  # @param [GeographicItem, Double]
  # @return [Scope] Georeferences
  def self.within_radius_of(geographic_item, distance)
    #.where{geographic_item_id in GeographicItem.within_radius_of('polygon', geographic_item, distance)}
    # geographic_item may be a polygon, or a point

    # TODO: Add different types of GeographicItems as we learn about why they are stored.
    # types of GeographicItems about which we currently know:
    # multipolygon  => stored through the NE/TDWG/GADM object load process
    # polygon       => stored through the GeoLocate process
    # point         => stored through the GeoLocate process
    temp     = GeographicItem.within_radius_of('multi_polygon', geographic_item, distance) +
      GeographicItem.within_radius_of('polygon', geographic_item, distance) +
      GeographicItem.within_radius_of('point', geographic_item, distance)
    partials = GeographicItem.where('id in (?)', temp.map(&:id))

    # the use of 'pluck(:id)' here, instead of 'map(&:id)' is because pluck instantiates just the ids,
    # and not the entire record, the way map does. pluck is only available on ActiveRecord::Relation
    # and related objects.
    Georeference.where('geographic_item_id in (?)', partials.pluck(:id))
  end

  # @param [String] locality string
  # @return [Scope] Georeferences
  # return all Georeferences that are attached to a CollectingEvent that has a verbatim_locality that
  # includes String somewhere
  # Joins collecting_event.rb and matches %String% against verbatim_locality
  # .where(id in CollectingEvent.where{verbatim_locality like "%var%"})
  def self.with_locality_like(string)
    with_locality_as(string, true)
  end

  # @param [String] locality string
  # @return [Scope] Georeferences
  # return all Georeferences that are attached to a CollectingEvent that has a verbatim_locality that
  # equals String somewhere
  # Joins collecting_event.rb and matches %String% against verbatim_locality
  # .where(id in CollectingEvent.where{verbatim_locality like "%var%"})
  def self.with_locality(string)
    with_locality_as(string, false)
  end

  # @param [GeographicArea]
  # @return [Scope] Georeferences
  # returns all georeferences which have collecting_events which have geographic_areas which match
  # geographic_areas as a GeographicArea
  # TODO: or, (in the future) a string matching a geographic_area.name
  def self.with_geographic_area(geographic_area)
    partials   = CollectingEvent.where(geographic_area: geographic_area)
    partial_gr = Georeference.where('collecting_event_id in (?)', partials.pluck(:id))
    partial_gr
  end

  ONE_WEST  = 111319.490779206
  ONE_NORTH = 110574.38855796

  # @return [GeographicItem] a square which represents either the bounding box of the
  # circle represented by the error_radius, or the bounding box of the error_geographic_item, whichever is greater.
  def error_box

    # POINT_ONE_DIAGONAL = 15690.343288662 # 15690.343288662  # Not used?
    # ONE_WEST           = 111319.490779206
    # ONE_NORTH          = 110574.38855796
    # TEN_WEST           = 1113194.90779206  # Not used?
    # TEN_NORTH          = 1105854.83323573  # Not used?

    # EARTH_RADIUS       = 6371000 # km, 3959 miles (mean Earth radius) # Not used?
    # RADIANS_PER_DEGREE = ::Math::PI/180.0
    # DEGREES_PER_RADIAN = 180.0/::Math::PI

    if error_radius.nil?
      # use the bounding box of the error_geo_item
      if error_geographic_item.nil?
        retval = nil
      else
        retval = error_geographic_item.dup
      end
    else
      if geographic_item.nil?
        retval = nil
      else
        # if this object is a point
        case geographic_item.geo_object_type
          when :point
            p0      = self.geographic_item.geo_object
            delta_x = (error_radius / ONE_WEST) / ::Math.cos(p0.y) # 111319.490779206 meters/degree
            delta_y = error_radius / ONE_NORTH # 110574.38855796 meters/degree
            # make a diamond 2 * radius tall and 2 * radius wide, with the reference point as center
=begin
            retval  = FACTORY.polygon(FACTORY.line_string([FACTORY.point(p0.x, p0.y + delta_y), # north
                                                           FACTORY.point(p0.x + delta_x, p0.y), # east
                                                           FACTORY.point(p0.x, p0.y - delta_y), # south
                                                           FACTORY.point(p0.x - delta_x, p0.y)  # west
                                                          ]))
            box     = RGeo::Cartesian::BoundingBox.new(FACTORY)
            box.add(retval)
            box_geom = box.to_geometry
=end

            # or
            # make the rectangle directly
            retval  = FACTORY.polygon(FACTORY.line_string([FACTORY.point(p0.x - delta_x, p0.y + delta_y), # northwest
                                                           FACTORY.point(p0.x + delta_x, p0.y + delta_y), # northeast
                                                           FACTORY.point(p0.x + delta_x, p0.y - delta_y), # southeast
                                                           FACTORY.point(p0.x - delta_x, p0.y - delta_y) # southwest
                                                          ]))
          when :polygon
            retval = geographic_item.geo_object
          else
            retval = nil
        end
        #retval = retval.to_geometry
      end
    end
    retval
  end

  # @return [Hash] formed as a GeoJSON 'Feature'.  Called by Gis::GeoJSON.feature_collection
  def to_geo_json_feature
    geometry = RGeo::GeoJSON.encode(self.geographic_item.geo_object)
    retval   = {
      'type'       => 'Feature',
      'geometry'   => geometry,
      'properties' => {'georeference' => {'id' => self.id}}
    }
    retval
  end

  protected

  # @param [String, Boolean] String to find in collecting_event.verbatim_locality, Bool = false for 'Starts with',
  # Bool = true if 'contains'
  # @return [Scope] Georeferences that are attached to a CollectingEvent that has a verbatim_locality that
  # includes, or is equal to 'string' somewhere
  # Joins collecting_event.rb and matches %String% against verbatim_locality
  # .where(id in CollectingEvent.where{verbatim_locality like "%var%"})
  def self.with_locality_as(string, like)
    likeness   = like ? '%' : ''
    like       = like ? 'like' : '='
    query      = "verbatim_locality #{like} '#{likeness}#{string}#{likeness}'"
    # where(id in CollectingEvent.where{verbatim_locality like "%var%"})
    partial_ce = CollectingEvent.where(query)

    partial_gr = Georeference.where('collecting_event_id in (?)', partial_ce.pluck(:id))
    partial_gr
  end

  # @return [Boolean] true if geographic_item is completely contained in error_geographic_item
  def chk_obj_inside_err_geo_item
    # case 1
    retval = true
    if error_geographic_item.nil? == false && geographic_item.nil? == false
      retval = self.error_geographic_item.contains?(self.geographic_item.geo_object)
    end
    retval
  end

  # @return [Boolean] true if geographic_item is completely contained in error_box
  def chk_obj_inside_err_radius
    # case 2
    retval = true
    if error_radius.nil? == false && geographic_item.nil? == false
      retval = self.error_box.contains?(self.geographic_item.geo_object)
    end
    retval
  end

  # @return [Boolean] true if error_geographic_item is completely contained in error_box
  def chk_err_geo_item_inside_err_radius
    # case 3
    retval = true
    if error_radius.nil? == false && error_geographic_item.nil? == false
      retval = self.error_box.contains?(error_geographic_item.geo_object)
    end
    retval
  end

  # @return [Boolean] true if error_box is completely contained in
  # collecting_event.geographic_area.default_geographic_item
  def chk_error_radius_inside_area
    # case 4
    retval = true
    unless collecting_event.nil?
      if error_radius.nil? == false && collecting_event.geographic_area.nil? == false
        retval = collecting_event.geographic_area.default_geographic_item.contains?(self.error_box)
      end
    end
    retval
  end

  # @return [Boolean] true if error_geographic_item.geo_object is completely contained in
  # collecting_event.geographic_area.default_geographic_item
  def chk_error_geo_item_inside_area
    # case 5
    retval = true
    unless collecting_event.nil?
      if error_geographic_item.nil? == false && collecting_event.geographic_area.nil? == false
        retval = collecting_event.geographic_area.default_geographic_item.contains?(error_geographic_item.geo_object)
      end
    end
    retval
  end

  # @return [Boolean] true if geographic_item.geo_object is completely contained in collecting_event.geographic_area.default_geographic_item
  def chk_obj_inside_area
    # case 6
    retval = true
    unless collecting_event.nil?
      unless collecting_event.geographic_area.nil?
        retval = collecting_event.geographic_area.default_geographic_item.contains?(geographic_item.geo_object)
      end
    end
    retval
  end

  # @return [Boolean] true iff collecting_event contains georeference geographic_item.
  def add_obj_inside_area
    if chk_obj_inside_area
      true
    else
      problem = 'collecting_event area must contain georeference geographic_item.'
      errors.add(:geographic_item, problem)
      errors.add(:collecting_event, problem)
      false
    end
  end

  # @return [Boolean] true iff collecting_event area contains georeference error_geographic_item.
  def add_error_geo_item_inside_area
    if chk_error_geo_item_inside_area
      true
    else
      problem = 'collecting_event area must contain georeference error_geographic_item.'
      errors.add(:error_geographic_item, problem)
      errors.add(:collecting_event, problem)
      false
    end
  end

  # @return [Boolean] true iff collecting_event area contains georeference error_radius bounding box.
  def add_error_radius_inside_area
    if chk_error_radius_inside_area
      true
    else
      problem = 'collecting_event area must contain georeference error_radius bounding box.'
      errors.add(:error_radius, problem)
      errors.add(:collecting_event, problem)
      false
    end
  end

  # @return [Boolean] true iff error_radius contains error_geographic_item.
  def add_err_geo_item_inside_err_radius
    if chk_err_geo_item_inside_err_radius
      true
    else
      problem = 'error_radius must contain error_geographic_item.'
      errors.add(:error_radius, problem)
      errors.add(:error_geographic_item, problem)
      false
    end
  end

  # @return [Boolean] true iff error_radius contains geographic_item.
  def add_obj_inside_err_radius
    if chk_obj_inside_err_radius
      true
    else
      errors.add(:error_radius, 'error_radius must contain geographic_item.')
      false
    end
  end

  # @return [Boolean] true iff error_geographic_item contains geographic_item.
  def add_obj_inside_err_geo_item
    if chk_obj_inside_err_geo_item
      true
    else
      errors.add(:error_geographic_item, 'error_geographic_item must contain geographic_item.')
      false
    end
  end

  # @return [Boolean] true iff error_depth is less than 8.8 kilometers (5.5 miles).
  def add_error_depth
    if error_depth.nil?
      true
    else
      if error_depth > 8800
        errors.add(:error_depth, 'error_depth must be less than 8.8 kilometers (5.5 miles).')
      end # 8,800 meters
      false
    end
  end

  # @return [Boolean] true iff error_radius is less than 20,000 kilometers (12,400 miles).
  def add_error_radius
    if error_radius.nil?
      true
    else
      if error_radius > 20000000
        errors.add(:error_radius, 'error_radius must be less than 20,000 kilometers (12,400 miles).')
      end # 20,000 km
      false
    end
  end

  # @param [Double, Double, Double, Double] two latitude/longitude pairs in decimal degrees
  #   find the heading between them.
  # @return [Double] Heading is returned as an angle in degrees clockwise from North.
  def heading(from_lat_, from_lon_, to_lat_, to_lon_)
    from_lat_rad_  = RADIANS_PER_DEGREE * from_lat_
    to_lat_rad_    = RADIANS_PER_DEGREE * to_lat_
    delta_lon_rad_ = RADIANS_PER_DEGREE * (to_lon_ - from_lon_)
    y_             = ::Math.sin(delta_lon_rad_) * ::Math.cos(to_lat_rad_)
    x_             = ::Math.cos(from_lat_rad_) * ::Math.sin(to_lat_rad_) -
      ::Math.sin(from_lat_rad_) * ::Math.cos(to_lat_rad_) * ::Math.cos(delta_lon_rad_)
    DEGREES_PER_RADIAN * ::Math.atan2(y_, x_)
  end
end
