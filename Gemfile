# Defaults. For supported versions check .travis.yml
ENV['rails'] ||= '3.2.8'
ENV['orm']   ||= 'active_record'

source :rubygems

gem 'jquery-rails'

# Define Rails version
rails_version = ENV['rails']
gem 'activesupport',  rails_version, :require => 'active_support'
gem 'actionpack',     rails_version, :require => 'action_pack'
gem 'actionmailer',   rails_version, :require => 'action_mailer'
gem 'activeresource', rails_version, :require => 'active_resource'
gem 'railties',       rails_version, :require => 'rails'
gem 'tzinfo'

case ENV['orm']
when 'active_record'
  gem 'activerecord', rails_version

when 'mongoid2'
  gem 'mongoid', '2.5.1'
  gem 'bson_ext', '~> 1.7'

when 'mongoid3'
  gem 'mongoid', '3.0.10'

when 'mongo_mapper'
  gem 'mongo_mapper', '0.12.0'
  gem 'bson_ext', '~> 1.7'

when 'data_mapper'
  gem 'generator_spec', :git => 'git://github.com/pnomolos/generator_spec'
  gem 'dm-core', '~> 1.2'
  gem 'dm-sqlite-adapter', '~> 1.2'
  gem 'dm-rails', '~> 1.2'
  gem 'dm-validations', '~> 1.2', :git => 'git://github.com/pnomolos/dm-validations', :branch => 'uniqueness_validator_fix'
  gem 'dm-migrations', '~> 1.2'
  gem 'dm-transactions', '~> 1.2'
  gem 'dm-timestamps', '~> 1.2'
  gem 'dm-constraints', '~> 1.2'
  gem 'dm-aggregates', '~> 1.2'
  gem 'dm-polymorphic', :git => 'git://github.com/bigblue/dm-polymorphic'

end

gemspec
