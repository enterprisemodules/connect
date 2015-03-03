require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new do |c|
  options = ['--color']
  options += ["--format", "documentation"]
  c.rspec_opts = options
end
 
task :default => [:lexer, :parser]

desc "Generate Lexer"
task :lexer do
  `rex lib/dsl/dsl.rex -o lib/dsl/lexer.rb`
end

desc "Generate Parser"
task :parser do
  `racc lib/dsl/dsl.y -v -E -o lib/dsl/parser.rb`
end