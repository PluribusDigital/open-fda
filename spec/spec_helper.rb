ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.default_wait_time = 10

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
# ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.include Capybara::DSL
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.clean_with :transaction
  end

  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.around(:each, type: :feature, js: true) do |ex|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    self.use_transactional_fixtures = false
    ex.run
    self.use_transactional_fixtures = true
    DatabaseCleaner.clean
  end

  # avoid setting type for each, instead set on folder
  config.infer_spec_type_from_file_location!

  # automatically parse json response body
  config.include Requests::JsonHelpers, type: :request

  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

end