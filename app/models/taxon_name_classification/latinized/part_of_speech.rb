class TaxonNameClassification::Latinized::PartOfSpeech < TaxonNameClassification::Latinized

  def self.applicable_ranks
    SPECIES_RANK_NAMES
  end

end