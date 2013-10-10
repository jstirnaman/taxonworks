class NomenclaturalRank::Icn::FamilyGroup::Family < NomenclaturalRank::Icn::FamilyGroup

  def self.parent_rank
      NomenclaturalRank::Icn::AboveFamily::Suborder
  end

  def self.validate_name_format(taxon_name)
    super
    taxon_name.errors.add(:name, 'name must end in -aceae') if not(taxon_name.name =~ /.*aceae\Z/)
  end

end