source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion        = ENV.key?('PUPPET_GEM_VERSION') ? "= #{ENV['PUPPET_GEM_VERSION']}" :  '>= 4.10.9'

if ENV.key?('PUPPET_GEM_VERSION') && Gem::Version.new(ENV['PUPPET_GEM_VERSION']) >= Gem::Version.new('6.0.0')
  resource_api_version = ENV.key?('PUPPET_RESOURCE_API_VERSION') ? "#{ENV['PUPPET_RESOURCE_API_VERSION']}" :  'v1.6.2'
  gem 'puppet-resource_api', :require => false, :ref => resource_api_version, :git => 'https://github.com/puppetlabs/puppet-resource_api.git'
end

gem 'puppet', puppetversion, :require => false, :groups => [:test]

group :unit_test do
  gem 'hiera-puppet-helper'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-puppet-utils'
  gem 'rspec-puppet'
end
group :acceptance_test do
  gem 'beaker', :require => false, :git => 'https://github.com/enterprisemodules/beaker.git'
  gem 'beaker-docker', :ref => '52a5fc118e699e01679e02d25e346e92142fead9', :git => 'https://github.com/enterprisemodules/beaker-docker.git'
  gem 'beaker-hiera'
  gem 'beaker-module_install_helper'
  gem 'beaker-pe'
  gem 'beaker-puppet_install_helper'
  gem 'beaker-rspec'
end
group :release do
  gem 'puppet-blacksmith'
end
group :quality do
  gem 'brakeman'
  gem 'bundle-audit'
  gem 'fasterer'
  gem 'metadata-json-lint'
  gem 'overcommit', :git => 'https://github.com/brigade/overcommit.git'
  gem 'puppet-lint'
  gem 'reek'
  gem 'rubocop', :require => false
end
group :unit_test, :acceptance_test do
  gem 'easy_type_helpers', :git => 'https://github.com/enterprisemodules/easy_type_helpers.git'
  gem 'puppetlabs_spec_helper'
end
