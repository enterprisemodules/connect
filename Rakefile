require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new do |c|
  options = ['--color']
  options += ["--format", "documentation"]
  c.rspec_opts = options
end
 
task :default => [:lexer, :parser]

desc "Generate Lexer"
task :lexer do
  `rex lib/connect/dsl.rex  -o lib/connect/lexer.rb`
end

desc "Generate Parser"
task :parser do
  `racc lib/connect/dsl.y -o lib/connect/parser.rb`
end