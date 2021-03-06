module TaxonNamesHelper

  def taxon_name_tag(taxon_name)
    return nil if taxon_name.nil?
    taxon_name.cached_html ? taxon_name.cached_html.html_safe : taxon_name.name
  end

  def taxon_name_link(taxon_name)
    return nil if taxon_name.nil?
    link_to(taxon_name_tag(taxon_name).html_safe, taxon_name)
  end

  def taxon_names_search_form
    render '/taxon_names/quick_search_form'
  end

  def taxon_name_for_select(taxon_name)
    taxon_name.name if taxon_name
  end

  # @taxon_name.parent.andand.display_name(:type => :for_select_list)
  def parent_taxon_name_for_select(taxon_name)
    taxon_name.parent ? taxon_name_for_select(taxon_name.parent) : nil
  end

  # TODO: Scope to code
  def taxon_name_rank_select_tag(taxon_name: TaxonName.new, code:  nil)
    select(:taxon_name, :rank_class, options_for_select(RANKS_SELECT_OPTIONS, selected: taxon_name.rank_string) ) 
  end

  def edit_original_combination_task_link(taxon_name)
    link_to('Edit original combination', edit_protonym_original_combination_task_path(taxon_name)) if GENUS_AND_SPECIES_RANK_NAMES.include?(taxon_name.rank_string)
  end

  def rank_tag(taxon_name)
    case taxon_name.type
    when 'Protonym'
      if @taxon_name.rank_class
        @taxon_name.rank.upcase
      else
        content_tag(:em, 'ERROR')
      end
    when 'Combination'
        content_tag(:em, 'n/a')
    end
  end
end
