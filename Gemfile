# ruby '2.1.5'

source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'thin'
gem 'faye'

# Heroku and New Relic
gem 'rails_12factor'
gem 'newrelic_rpm'

# Assets
gem 'jquery-rails'
gem 'turbolinks'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'bootstrap-sass'
gem 'therubyracer', require: 'v8'
gem 'yui-compressor'
gem 'font-awesome-rails'
gem 'responders'

# Custom gems
gem 'pivotal-tracker'
gem 'backtop'
gem 'mongoid', github: 'mongoid'
gem 'bson_ext'

gem 'rspec-rails', group: [:test, :development]

group :test do
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'rack_session_access'
  gem 'mocha', require: false
  gem 'zeus', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'codeclimate-test-reporter', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
