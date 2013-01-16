module Doorkeeper
  class Owner
    include DataMapper::Resource
    storage_names[:default] = 'placeholder_application_owners'
    has n, :applications, :as => 'owner', :model => 'Doorkeeper::Application'
    
    property :id, Serial
  end

  module OrmHelper
    def mock_application_owner
      Owner.new
    end
  end
end

DataMapper.auto_migrate!
DataMapper.finalize
