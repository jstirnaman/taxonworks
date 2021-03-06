module Tasks::Gis::LocalityHelper

  def collecting_event_georeference_count(collecting_event)
    count = collecting_event.georeferences.count - 1
    if count > 0
      count.to_s
    else
      'none'
    end
  end

  def distance_between(collecting_event_1, collecting_event_2)
    distance = collecting_event_1.distance_to(collecting_event_2.geographic_items.first).round # to the nearest meter
    case
      when distance >= 1000.0
        metric   = "%1.3fkm"
        distance /= 1000.0
      else
        metric = "%im"
    end
    metric % distance
  end

  def nearby_link(collecting_event)
    return nil if collecting_event.nil?
    link_to('nearby', collecting_event)
  end

  def distance_select_tag(digit, tag_string)
    tag = tag_string.gsub(',', '')

    label_tag(digit, tag_string)
    radio_button_tag(digit, tag.to_s)
  end

  def is_checked(digit, value)
    (params[digit] == value) ? true : false
  end

end
