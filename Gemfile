source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.beta3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks','~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'webpacker'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Use the following gems for rspec testing
  # gem 'rspec-rails', '~> 3.8'
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end  
  # Fast creation of test objects
  gem 'factory_bot_rails'
  # Lets us mock web calls
  gem 'webmock'
  # Allows us to create a fake API
  gem 'vcr'

  gem 'ffaker'

  # Allow console debugging
  gem 'ruby-debug-ide'
  gem 'debase'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  
  # better errors for debugging
  gem 'better_errors'
  gem 'binding_of_caller'
  
  #httplog to get all messages sent to/from server
  gem 'httplog'

  # Pry for debugging goodness
  gem 'pry-rails'

  # All them rules for development
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
  gem 'action-cable-testing'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing' # If you are using Rails 5.x
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# User authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-wonde', :path=>"omniauth-wonde/"

# Simple forms
gem 'simple_form'

# Slim for clean HTML
gem 'slim'

# Pundit to control authorization
gem 'pundit'

# Gon to pass rails variables to Javascript
gem 'gon'

# Wonde client to easily access Wonde data
gem 'wondeclient'

# Pretty things!
# Bootstrap and JQuery for Bootstrap!
gem 'bootstrap'
gem 'jquery-rails'
gem 'font-awesome-sass'

# High-voltage for our static pages (e.g. home)
gem 'high_voltage'

#Required for rails 6.1 (recommeneded 1.2)
gem 'image_processing'

# In place editing for answers
gem 'best_in_place'

# Use Amazon S3 for Active Storage
gem 'aws-sdk-s3'