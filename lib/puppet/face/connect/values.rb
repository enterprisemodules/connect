require_relative './../../../scope.rb'
require_relative './../../../definition_reader.rb'
require_relative './../../../reference_reader.rb'
require_relative './../../../inspector.rb'

require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'

begin
  require 'awesome_print'
rescue LoadError
  "Ignore error's in loading these files"
end

#
# rubocop:disable Metrics/BlockLength
#
Puppet::Face.define(:connect, '0.0.1') do
  self.class.include Scope
  self.class.include DefinitionReader
  self.class.include ReferenceReader
  self.class.include Inspector

  action(:values) do
    default
    summary 'List the value(s) specified in the connect config file(s)'

    description <<-DOCS
      List the value(s) specified in the connect config file(s). If you specify a parameter name,
      Connect wil show you the specified name. You can use regular expression wildcards for the name.
    DOCS

    option '--all', '-a' do
      summary 'List all values'
      description <<-DOCS
        List all values
      DOCS
    end

    examples <<-DOCS

      Given a connect config file:

        a_value = 10
        my_scope::b_value = a

      When you want to see the value of a_value:

      $ puppet connect values a_value

      To see the value of b_value:

      $ puppet connect values my_scope::b_value

    DOCS

    arguments '<variable_name>'

    when_invoked do |name, _options|
      puts 'installing awesome_print gem, improves the output readability.' unless defined?(AwesomePrint::Inspector)
      config_dir = Puppet['confdir']
      Hiera.new(:config => "#{config_dir}/hiera.yaml")
      backend = Hiera::Backend::Connect_backend.new
      values_list = backend.lookup_values(name, scope, false, 1)
      output = ''
      values_list.each do |parameter, value|
        output << definitions_for(parameter, backend)
        output << references_for(parameter, backend)
        output << "#{parameter} = #{inspect(value)}\n"
      end
      output
    end
  end
end
#
# rubocop:enable Metrics/BlockLength
#
