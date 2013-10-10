class NomenclaturalRank::Iczn::FamilyGroup::Tribe < NomenclaturalRank::Iczn::FamilyGroup

  def self.parent_rank
    NomenclaturalRank::Iczn::FamilyGroup::Supertribe
  end

  def self.validate_name_format(taxon_name)
    super
    taxon_name.errors.add(:name, 'name must end in ini') if not(taxon_name.name =~ /.*ini\Z/)
  end
end