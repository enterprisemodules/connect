source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rexical'
  gem 'racc'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'guard-rspec'   , :require => false
  gem 'guard-bundler' , :require => false
  gem 'ruby_gntp'
  gem 'bogus'
  gem 'byebug'
  gem 'rubocop'       , :require => false
  gem 'yard'          , :require => false
  gem 'coveralls'     , :require => false
  gem "puppet-blacksmith"
end

gem 'hiera'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

