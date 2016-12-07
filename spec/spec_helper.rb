require 'puppet'
if RUBY_VERSION[0,3] == '1.8'
  require 'backports'
  #
  # Fix a problem introduced by monky patching in Puppet
  # See https://github.com/rspec/rspec-core/issues/1864 for more information
  #
  class Symbol
    alias to_proc __original_to_proc
  end
end

# Set prepend lib's from all modules to current path
module_path = Pathname(__FILE__).parent + 'fixtures' + 'modules'
module_path.children.each  do | dir |
  lib_path = dir + 'lib'
  $:.unshift(lib_path)
end


require 'rspec'
require 'rspec/collection_matchers'
require 'rspec/its'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  # config.warnings = false
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # # config.profile_examples = 10
  # config.order = :random
  # Kernel.srand config.seed
end
