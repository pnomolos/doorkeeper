require 'dm-rails/mass_assignment_security'
require 'doorkeeper/models/data_mapper/revocable'
require 'doorkeeper/models/data_mapper/scopes'

module Doorkeeper
  class AccessToken
    include DataMapper::Resource
    include DataMapper::MassAssignmentSecurity
    include Doorkeeper::Models::DataMapper::Revocable

    storage_names[:default] = 'oauth_access_tokens'

    property :id,                Serial
    property :resource_owner_id, Integer
    property :application_id,    Integer, :required => true
    property :token,             String, :required => true, :length => 0..1024
    property :refresh_token,     String, :unique => true, :length => 1024
    property :expires_in,        Integer, :default => 0
    property :revoked_at,        DateTime
    property :scopes,            DataMapper::Property::OAuthScopes, :allow_nil => true
    property :created_at,        DateTime, :default => DateTime.now

    def self.delete_all_for(application_id, resource_owner)
      all(:application_id => application_id,
            :resource_owner_id => resource_owner.id).destroy
    end
    private_class_method :delete_all_for

    def self.last_authorized_token_for(application, resource_owner_id)
      first(:application_id => application.id,
            :resource_owner_id => resource_owner_id,
            :revoked_at => nil,
            :order => [:created_at.desc])
    end
    private_class_method :last_authorized_token_for

    def write_attribute(field, val)
      send("#{field}=", val)
    end
    
    def expires_in_seconds
      expires_in.seconds
    end
  end
end
