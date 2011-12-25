source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less'
  gem 'less-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :test, :development do
  gem 'jasmine', git: 'git://github.com/pivotal/jasmine-gem.git'
  gem 'jasmine-headless-webkit'

  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'launchy'

  gem 'guard'
  gem 'guard-rails-assets'
  gem 'guard-jasmine-headless-webkit'
  gem 'growl'
  gem 'rb-fsevent', require: false
end

gem 'jquery-rails'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mongoid', '2.3.3'
gem 'bson_ext'                                # faster C-based JSON lib
gem 'ruby-mp3info'                            # for ID3 tag parsing
gem 'haml'                                    # for view templates
gem 'rmagick',      :require => "RMagick"     # for image processing
gem 'devise'                                  # for user authentication
gem 'httparty'                                # for talking to AWS
gem 'ruby-hmac'                               # for generating AWS API signatures

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
