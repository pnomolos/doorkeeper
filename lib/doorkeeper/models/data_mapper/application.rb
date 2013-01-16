require 'dm-rails/mass_assignment_security'
require 'doorkeeper/models/data_mapper/compatibility'

module Doorkeeper
  class Application
    include DataMapper::Resource
    include DataMapper::MassAssignmentSecurity

    storage_names[:default] = 'oauth_applications'

    property :id,           Serial
    property :name,         String, :required => true
    property :uid,          String, :required => true, :length => 1..1024
    property :secret,       String, :required => true, :length => 1..1024
    property :redirect_uri, String, :required => true
    property :scopes,       String
    property :owner_type,   Class
    property :owner_id,     Integer
    property :created_at,   DateTime, :default => DateTime.now

    has n, :authorized_tokens, :model => AccessToken, :conditions => { :revoked_at => nil }, :constraint => :destroy

    def self.authorized_for(resource_owner)
      ids = AccessToken.all(:resource_owner_id => resource_owner.id, :revoked_at => nil).map(&:application_id)
      all(:id => ids)
    end
  end
end
