module Doorkeeper
  class Application
    include Doorkeeper::OAuth::Helpers

    case DOORKEEPER_ORM
      when :data_mapper
        has n, :access_grants, :constraint => :destroy, :model => Doorkeeper::AccessGrant
        has n, :access_tokens, :constraint => :destroy, :model => Doorkeeper::AccessToken
      else
        has_many :access_grants, :dependent => :destroy, :class_name => "Doorkeeper::AccessGrant"
        has_many :access_tokens, :dependent => :destroy, :class_name => "Doorkeeper::AccessToken"
    end

    present_fields = [:name, :secret, :uid, :redirect_uri]
    unique_fields = [:uid]

    case DOORKEEPER_ORM
      when :data_mapper
        validates_presence_of(*present_fields)
        validates_uniqueness_of(*unique_fields)
        validates_redirect_uri(:redirect_uri)
        before :valid? do |context = :default| 
          return true unless new?
          generate_uid
          generate_secret
        end
      else
        validates(*present_fields, :presence => true)
        validates(*unique_fields, :uniqueness => true)
        validates :redirect_uri, :redirect_uri => true
        before_validation :generate_uid, :generate_secret, :on => :create
    end

    attr_accessible :name, :redirect_uri

    def self.model_name
      ::ActiveModel::Name.new(self, Doorkeeper, 'Application')
    end
  
    case DOORKEEPER_ORM
      when :data_mapper
        def self.authenticate(uid, secret)
          first(:uid => uid, :secret => secret)
        end

        def self.by_uid(uid)
          first(:uid => uid)
        end
      else
        def self.authenticate(uid, secret)
          self.where(:uid => uid, :secret => secret).first
        end

        def self.by_uid(uid)
          self.where(:uid => uid).first
        end
    end

    private

    def generate_uid
      self.uid = UniqueToken.generate
    end

    def generate_secret
      self.secret = UniqueToken.generate
    end
  end
end
