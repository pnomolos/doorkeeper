module Doorkeeper
  module Models
    module Ownership
      def validate_owner?
        Doorkeeper.configuration.confirm_application_owner?
      end    
  
      def self.included(base)
        base.class_eval do
          case DOORKEEPER_ORM
            when :data_mapper
              belongs_to :owner, :polymorphic => true, :suffic => :type
              validates_presence_of :owner, :if => :validate_owner?
            else
              belongs_to :owner, :polymorphic => true
              validates :owner, :presence => true, :if => :validate_owner?
          end
        end
      end
    end
  end
end