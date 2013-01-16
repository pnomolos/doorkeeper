case DOORKEEPER_ORM
when :active_record
  class User < ActiveRecord::Base
  end
when :mongoid2, :mongoid3
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, :type => String
    field :password, :type => String
  end
when :mongo_mapper
  class User
    include MongoMapper::Document
    timestamps!

    key :name,     String
    key :password, String
  end
when :data_mapper
  require 'dm-rails/mass_assignment_security'
  class User
    include DataMapper::Resource
    include DataMapper::MassAssignmentSecurity
    
    property :id, Serial
    property :name, String
    property :password, String
    timestamps :at
  end
end

class User
  attr_accessible :name, :password

  def self.authenticate!(name, password)
    User.where(:name => name, :password => password).first
  end
end

if :data_mapper == DOORKEEPER_ORM
  class User
    def self.authenticate!(name, password)
      User.first(:name => name, :password => password)
    end
  end
end
