module Doorkeeper
  module Models
    module DataMapper
      module Revocable
        def self.included(base)
          base.class_eval do
            def update_column(attr, val)
              self.send("#{attr}=", val)
              self.save!
            end
          end
        end
      end
    end
  end
end
