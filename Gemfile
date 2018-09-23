source 'https://rubygems.org'

gem 'rails', '4.2.5.1'
gem 'thin'
gem 'faye'
gem 'rest-client'
gem 'json'
gem 'tracker_api'
gem 'pg', '~> 0.21'
gem 'sqlite3'

# Heroku and New Relic
gem 'rails_12factor'
gem 'newrelic_rpm'

# Assets
gem 'jquery-rails'
gem 'turbolinks'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-sass'
gem 'therubyracer', require: 'v8'
gem 'yui-compressor'
gem 'font-awesome-rails'
gem 'responders', '~> 2.0'

# Custom gems
gem 'pivotal-tracker'
gem 'backtop'
gem 'bson_ext'
gem 'google-api-client', '~> 0.8'

gem 'rspec-rails', '~> 3.6.1', group: [:test, :development]

group :test do
  gem 'factory_bot_rails'
  gem 'forgery'
  gem 'capybara', "2.4.4"
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'rack_session_access'
  gem 'simplecov', require: false
  gem 'mocha', require: false
  gem 'zeus', require: false
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels' # basic imperative step defs
end

group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'capistrano', ' 3.0', require: false
  # gem 'capistrano-rails', '1.1', require: false
  # gem 'capistrano-bundler', '~> 1.1', require: false
  # gem 'capistrano-rvm', '~> 0.1', require: false
end

gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
