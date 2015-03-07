require 'puppet'
if RUBY_VERSION[0,3] != '1.8'
  require 'bogus/rspec'
  require 'coveralls'
  Coveralls.wear!
else
  #
  # Fix a problem introduced by monky patching in Puppet
  # See https://github.com/rspec/rspec-core/issues/1864 for more information
  #
  class Symbol
    alias to_proc __original_to_proc
  end
end

require 'rspec'


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
