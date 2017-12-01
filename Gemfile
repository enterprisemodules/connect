source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? "= #{ENV['PUPPET_GEM_VERSION']}" : ['>= 4.0']

gem 'puppet', puppetversion

group :unit_test do
  gem 'rspec-its'
  gem 'rspec-collection_matchers'
  gem 'rspec-puppet-utils'
  gem 'hiera-puppet-helper'
  gem 'rspec-puppet'
end

group :acceptance_test do
  gem 'beaker-rspec'
  gem 'beaker-hiera'
  gem 'beaker-docker', git: 'https://github.com/enterprisemodules/beaker-docker.git',
                       ref: '52a5fc118e699e01679e02d25e346e92142fead9'
  gem 'beaker-pe'
  gem 'beaker-module_install_helper'
  gem 'beaker-puppet_install_helper'
  gem 'beaker'
end

group :release do
  gem 'puppet-blacksmith'
end

group :quality do
  gem 'puppet-lint'
  gem 'rubocop',      :require => false
  gem 'overcommit'
  gem 'fasterer'
  gem 'bundler-audit'
  gem 'reek'
  gem 'brakeman'
  gem 'metadata-json-lint'
end

group :unit_test, :acceptance_test do
  gem 'puppetlabs_spec_helper'
  gem 'easy_type_helpers', :git => 'https://github.com/enterprisemodules/easy_type_helpers.git'
end
