class NomenclaturalRank::Iczn::SpeciesGroup::Species < NomenclaturalRank::Iczn::SpeciesGroup

  def self.parent_rank
    NomenclaturalRank::Iczn::SpeciesGroup::SpeciesSubgroup
  end

  def self.abbreviation
    'sp.'
  end
end
