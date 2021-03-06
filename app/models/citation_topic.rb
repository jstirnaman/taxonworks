class CitationTopic < ActiveRecord::Base

  include Housekeeping
  include Shared::IsData

  belongs_to :topic, inverse_of: :citation_topics
  belongs_to :citation, inverse_of: :citation_topics

  validates_presence_of :topic_id, :citation_id
  validates_uniqueness_of :topic_id, :citation_id

  # deprecated, all values are nilified
  nil_trim_attributes(:pages)

  protected

end
