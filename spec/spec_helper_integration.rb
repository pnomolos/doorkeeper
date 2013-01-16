ENV["RAILS_ENV"] ||= 'test'
DOORKEEPER_ORM = (ENV['orm'] || :active_record).to_sym

$:.unshift File.dirname(__FILE__)

require 'dummy/config/environment'
require 'rspec/rails'
require 'rspec/autorun'
require 'generator_spec/test_case'
require 'timecop'
require 'database_cleaner'

puts "====> Doorkeeper.orm = #{Doorkeeper.configuration.orm.inspect}"
puts "====> Rails version: #{Rails.version}"
puts "====> Ruby version: #{RUBY_VERSION}"

require "support/orm/#{Doorkeeper.configuration.orm_name}"

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

Dir["#{File.dirname(__FILE__)}/support/{dependencies,helpers,shared}/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.infer_base_class_for_anonymous_controllers = false

  config.before :suite do
    if :data_mapper == DOORKEEPER_ORM
      DataMapper.finalize
      DataMapper.auto_migrate!
    end
  end
  
  config.before do
    DatabaseCleaner.start
    Doorkeeper.configure {
      orm DOORKEEPER_ORM
    }
  end
  
  if :data_mapper == DOORKEEPER_ORM
    config.before :all do
      DataMapper.finalize
    end
    config.before :each do
      DataMapper.finalize
    end
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'random'

  config.before(:each) do |x|
    full_example_description = "#{x.example.metadata[:example_group][:full_description]}"
    Rails.logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")
  end
end
