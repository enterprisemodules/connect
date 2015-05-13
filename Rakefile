require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'rspec-system/rake_task'
rescue LoadError
end

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end
 
task :default => [:lexer, :parser]

desc "Build the module"
task :build do
  `puppet module build`
end

desc "Generate Lexer"
task :lexer do
  `rex lib/connect/dsl.rex  -o lib/connect/lexer.rb`
end

desc "Generate Parser"
task :parser do
  `racc lib/connect/dsl.y -v -o lib/connect/parser.rb`
end
