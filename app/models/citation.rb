# Citation is like Roles in that it is also a linking table between a data object & a source.
# (Assertion that the subject was referenced in a source)
class Citation < ActiveRecord::Base
  include Housekeeping
  include Shared::IsData
  include Shared::Annotates

  belongs_to :citation_object, polymorphic: :true
  belongs_to :source, inverse_of: :citations

  has_many :citation_topics, inverse_of: :citation

  validates_presence_of :citation_object_id, :citation_object_type, :source_id
  validates_uniqueness_of :source_id, scope: [:citation_object_type, :citation_object_id]

  # @return [Scope of matching sources]
  def self.find_for_autocomplete(params)
    term    = params['term']
    ending  = term + '%'
    wrapped = '%' + term + '%'
    joins(:source).where('sources.cached ILIKE ? OR sources.cached ILIKE ? OR citation_object_type LIKE ?', ending, wrapped, ending)
  end

  # @return [NoteObject]
  #   alias to simplify reference across classes 
  def annotated_object
    citation_object
  end

end
