class TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished::Illegitimate < TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished

  def self.disjoint_taxon_name_classes
    self.parent.disjoint_taxon_name_classes +
        [TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished.to_s] +
        TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished::Legitimate.descendants.collect{|t| t.to_s} +
        [TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished::Legitimate.to_s]
  end

end