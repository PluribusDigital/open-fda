source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'
# Bower to manage front-end dependencies
gem 'bower-rails'
# Use SCSS for stylesheets
gem 'sass', '3.2.19' 
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# HTTParty to interact with external REST APIs
gem 'httparty'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'angular-rails-templates', '~> 0.1.3'

group :production, :staging do
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
end

group :development do 
  gem "better_errors"
  gem "binding_of_caller"
  gem 'spring'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'cucumber-rails', :require => false
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "teaspoon-jasmine"
  gem "poltergeist"
  gem "phantomjs"
  gem 'dotenv-rails'
end

# Windows
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]