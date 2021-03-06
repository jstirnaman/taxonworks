
# Discussion (MJY, DD, 1/9/15) - It may be that this is semantically identical to Combination, and that we can infer the difference, i.e. functionality
# might get simplified/merged in the future.
# 
class TaxonNameRelationship::OriginalCombination < TaxonNameRelationship

  validates_uniqueness_of :object_taxon_name_id, scope: :type

  def self.nomenclatural_priority
    :reverse
  end

  def self.order_index
    RANKS.index(::ICN_LOOKUP[self.object_relationship_name.gsub('original ', '')])
  end

end
