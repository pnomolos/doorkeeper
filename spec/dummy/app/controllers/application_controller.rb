case DOORKEEPER_ORM
  when :data_mapper
    require 'dm-rails/middleware/identity_map'
    class ApplicationController < ActionController::Base
      use Rails::DataMapper::Middleware::IdentityMap
      protect_from_forgery
    end
  else
    class ApplicationController < ActionController::Base
      protect_from_forgery
    end
end