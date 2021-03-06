module GeographicAreasHelper

  def self.geographic_area_tag(geographic_area)
    return nil if geographic_area.nil?
    geographic_area.name
  end

  def geographic_area_tag(geographic_area)
    GeographicAreasHelper.geographic_area_tag(geographic_area)
  end

  # TODO: reference content_tag w/in self, more logical string subtraction
  def self.geographic_area_autocomplete_tag(geographic_area, term = '')
    return nil if geographic_area.nil?
    show_this =  geographic_area.name.gsub(/#{term}/, "<mark>#{term}</mark>") # weee bit simpler
    show_this += " (#{geographic_area.geographic_area_type.name})" unless geographic_area.geographic_area_type.nil?
    show_this += " [#{geographic_area.parent.name}]" unless geographic_area.parent.nil?
    show_this.html_safe
  end

  def geographic_area_link(geographic_area, link_text = nil)
    return nil if geographic_area.nil?
    link_text ||= geographic_area.name
    link_to(link_text, geographic_area)
  end

  def geographic_areas_search_form
    render('/geographic_areas/quick_search_form')
  end

  def geographic_areas_link_list_tag(geographic_areas)
    geographic_areas.collect { |ga| link_to(ga.name, ga) }.join(",")
  end

  def geographic_area_link_list(geographic_areas)
    content_tag(:ul) do
      geographic_areas.collect { |a| content_tag(:li, geographic_area_link(a)) }.join.html_safe
    end
  end

end
