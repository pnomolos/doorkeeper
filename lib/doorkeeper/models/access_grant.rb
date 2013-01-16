module Doorkeeper
  class AccessGrant
    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Expirable
    include Doorkeeper::Models::Revocable
    include Doorkeeper::Models::Accessible
    include Doorkeeper::Models::Scopes
    
    case DOORKEEPER_ORM
      when :data_mapper
        belongs_to :application, :model => Doorkeeper::Application
      else
        belongs_to :application, :class_name => "Doorkeeper::Application", :inverse_of => :access_grants
    end

    attr_accessible :resource_owner_id, :application_id, :expires_in, :redirect_uri, :scopes

    present_fields = [:resource_owner_id, :application_id, :token, :expires_in, :redirect_uri]
    unique_fields = [:token]
    
    case DOORKEEPER_ORM
      when :data_mapper
        validates_presence_of(*present_fields)
        validates_uniqueness_of(*unique_fields)
        before :valid? do 
          generate_token if new?
          true
        end
        def self.authenticate(token)
          all(:token => token).first
        end
      else
        validates(*present_fields, :presence => true)
        validates(*unique_fields, :uniqueness => true)
        before_validation :generate_token, :on => :create
        def self.authenticate(token)
          where(:token => token).first
        end
    end

    private

    def generate_token
      self.token = UniqueToken.generate
    end
  end
end
