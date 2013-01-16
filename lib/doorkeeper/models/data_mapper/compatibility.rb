require 'uri'

module DataMapper
  module Validations
    class RedirectUriValidator < GenericValidator
      
      def self.test_redirect_uri
        Doorkeeper.configuration.test_redirect_uri
      end
      
      def test_redirect_uri?(uri)
        self.class.test_redirect_uri.present? && uri.to_s == self.class.test_redirect_uri.to_s
      end
      
      def call(target)
        value = target.validation_property_value(field_name)
        return true if value == ''

        error_messages = []
        begin
          uri = ::URI.parse(value)
          return true if test_redirect_uri?(uri)

          error_messages << :fragment_present unless uri.fragment.nil?
          error_messages << :relative_uri if uri.scheme.nil? || uri.host.nil?
          error_messages << :has_query_parameter unless uri.query.nil?
        rescue URI::InvalidURIError
          error_messages << :invalid_uri
        end

        return true if error_messages.empty?

        error_messages.each do |message|
          add_error(target, ValidationErrors.default_error_message(message, field_name), field_name)
        end
        false
      end
    end
    
    module ValidatesRedirectUri
      def validates_redirect_uri(*fields)
        validators.add(RedirectUriValidator, *fields)
      end
    end
  end
end

module DataMapper
  module Validations
    module ClassMethods
      include DataMapper::Validations::ValidatesRedirectUri
    end
  end
end

module DataObjects
  module Quoting
    alias_method :original_quote_value, :quote_value
    def quote_value(value)
      case value
        when ActiveSupport::Duration then quote_numeric(value)
        else
          original_quote_value(value)
      end
    end
  end
end

# TODO: Read these from the I18N file
module DataMapper
  module Validations
     class ValidationErrors
       mattr_accessor :default_error_messages
     end
  end
end

DataMapper::Validations::ValidationErrors.default_error_messages = DataMapper::Validations::ValidationErrors.default_error_messages.merge({
  :fragment_present => 'cannot contain a fragment.',
  :relative_uri => 'must be an absolute URI.',
  :has_query_parameter => 'cannot contain a query parameter.',
  :invalid_uri => 'must be a valid URI.'
})