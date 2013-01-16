$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "../app"))

if :data_mapper == DOORKEEPER_ORM
  module FactoryGirl
    class Strategy
      class Create < Strategy
        def result(attribute_assigner, to_create)
          attribute_assigner.object.tap do |result_instance|
            run_callbacks(:after_build, result_instance)
            result_instance.save or raise(result_instance.errors.send(:errors).map{|attr,errors| "- #{attr}: #{errors}" }.join("\n"))
            run_callbacks(:after_create, result_instance)
          end
        end
      end
    end
  end
end