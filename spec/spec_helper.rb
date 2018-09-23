prefork = -> {
  ENV["RAILS_ENV"] = 'test'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'forgery/forgery'
  require 'mocha/setup'

  # Add this to load Capybara integration:
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'rack_session_access/capybara'
  require 'selenium-webdriver'

  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/config/"
  end

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :mocha
    config.infer_base_class_for_anonymous_controllers = false
    # config.order = "random"

    ['Basic', 'Project', 'Story'].each do |fixture|
      config.include "Support::Fixtures::#{fixture}Fixture".constantize
    end

    ['Application', 'Sessions', 'Dashboard', 'Views'].each do |helper|
      config.include "Support::Helpers::#{helper}Helper".constantize
    end

    config.before(:each) do
      DatabaseCleaner.clean_with :truncation
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
}

each_run = -> {
  # Reload routes in config/routes.rb.
  Rails.application.reload_routes!

  # Reload factories in spec/factories.
  FactoryBot.reload

  # Reload language bundles in config/locales.
  I18n.backend.reload!
}

if defined?(Zeus)
  prefork.call
  $each_run = each_run
  class << Zeus.plan
    def after_fork_with_test
      after_fork_without_test
      $each_run.call
    end
    alias_method_chain :after_fork, :test
  end
else
  prefork.call
  each_run.call
end