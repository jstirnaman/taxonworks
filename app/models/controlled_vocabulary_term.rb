
class ControlledVocabularyTerm < ActiveRecord::Base

  include Housekeeping
  include Shared::AlternateValues
  include Shared::IsData
  # include Shared::Taggable <- NO!!

  has_paper_trail

  # Class constants
  ALTERNATE_VALUES_FOR = [:name, :definition]

  validates_presence_of :name, :definition, :type
  validates_length_of :definition, minimum: 4

  validates_uniqueness_of :name, scope: [:type, :project_id]
  validates_uniqueness_of :definition, scope: [:project_id]
  validates_uniqueness_of :uri, scope: [:project_id, :uri_relation], allow_blank: true
  validates_presence_of :uri_relation, unless: 'uri.blank?', message: 'must be provided if uri is provided'
  validates_presence_of :uri, unless: 'uri_relation.blank?', message: 'must be provided if uri_relation is provided'

  validate :uri_relation_is_a_skos_relation, unless: 'uri_relation.blank?'

  def self.find_for_autocomplete(params)
    term = "#{params[:term]}%"
    where('name LIKE ? OR definition LIKE ?', term, "#{term}%" )
  end

  protected 

  def uri_relation_is_a_skos_relation
    errors.add(:uri_relation, 'is not a valid uri relation') if !SKOS_RELATIONS.keys.include?(uri_relation)
  end

end
