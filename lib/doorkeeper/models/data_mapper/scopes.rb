module DataMapper
  class Property
    class OAuthScopes < DataMapper::Property::String

      def custom?
        true
      end

      def load(value)
        return value
        
        case value
          when ::String then Doorkeeper::OAuth::Scopes.from_string value
          when ::Array then Doorkeeper::OAuth::Scopes.from_array value
        end
      end

      def dump(value)
        case value
          when Doorkeeper::OAuth::Scopes then value.to_s
          when ::String then value
        end
      end
    end
  end
end
