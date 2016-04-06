source 'https://rubygems.org'

group :development, :test do
  unless RUBY_PLATFORM == 'java'
    gem 'pry'
    gem 'pry-byebug'
    gem 'pry-stack_explorer'
    gem 'guard-rspec'   , :require => false
    gem 'guard-bundler' , :require => false
    gem 'ruby_gntp'
    gem 'byebug'
  else
    gem 'pry'
    gem 'ruby-debug'    
  end
  gem "codeclimate-test-reporter",  require: nil
  gem 'rake'
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rexical'
  gem 'racc'
  gem 'bogus'
  gem 'rubocop'       , :require => false
  gem 'yard'          , :require => false
  gem 'coveralls'     , :require => false
  gem "puppet-blacksmith"
  gem "puppetlabs_spec_helper"
end

if hieraversion = ENV['HIERA_GEM_VERSION']
  gem 'hiera', hieraversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'awesome_print'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

