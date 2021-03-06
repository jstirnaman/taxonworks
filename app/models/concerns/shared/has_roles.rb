module Shared::HasRoles

  extend ActiveSupport::Concern
  included do
    has_many :roles, as: :role_object
  end

  def has_roles?
    self.roles.size > 0
  end

end
