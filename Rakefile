require 'rspec/core/rake_task'
begin
  require 'puppet_blacksmith/rake_tasks'
  require 'puppetlabs_spec_helper/rake_tasks'
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