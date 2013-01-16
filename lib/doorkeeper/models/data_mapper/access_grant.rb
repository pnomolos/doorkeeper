require 'dm-rails/mass_assignment_security'
require 'doorkeeper/models/data_mapper/revocable'
require 'doorkeeper/models/data_mapper/scopes'

module Doorkeeper
  class AccessGrant
    include DataMapper::Resource
    include DataMapper::MassAssignmentSecurity
    include Doorkeeper::Models::DataMapper::Revocable

    storage_names[:default] = 'oauth_access_grants'

    property :id,                Serial
    property :resource_owner_id, Integer
    property :application_id,    Integer, :required => true
    property :token,             String, :required => true, :length => 0..1024
    property :redirect_uri,      String, :length => 0..1024
    property :expires_in,        Integer, :default => 0
    property :revoked_at,        DateTime
    property :scopes,            DataMapper::Property::OAuthScopes, :allow_nil => true
    property :created_at,        DateTime, :default => DateTime.now
  end
end
