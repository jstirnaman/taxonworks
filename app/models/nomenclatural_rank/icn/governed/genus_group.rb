class NomenclaturalRank::Icn::Governed::GenusGroup <  NomenclaturalRank::Icn::Governed

  def self.validate_name_format(taxon_name)
    taxon_name.errors.add(:name, 'name must be capitalized') if not(taxon_name.name = taxon_name.name.capitalize)
  end

  def parent_rank
    nil
  end

  def name
    nil
  end

end