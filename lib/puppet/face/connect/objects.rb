require_relative './../../../scope.rb'
require_relative './../../../inspector.rb'

require 'puppet/face'

#
# rubocop:disable Metrics/BlockLength
#
Puppet::Face.define(:connect, '0.0.1') do
  self.class.include Scope
  self.class.include Inspector

  action(:objects) do
    summary 'List the objects specified in the connect config file(s)'

    option '--type OBJECT_TYPE', '-t OBJECT_TYPE' do
      summary 'Object type to list'
      description <<-DOCS
        Type of objects to list.
      DOCS
    end

    option '--all', '-a' do
      summary 'List all objects'
      description <<-DOCS
        List all objects
      DOCS
    end

    description <<-DOCS
      List the object(s) specified in the connect config file(s). If you specfy a parameter name,
      Connect wil show you the specified object. You can use regular expresion wildcards for the name.
    DOCS

    examples <<-DOCS

      Given a connect config file:

        host('www.apache.org') {
          ip: '10.0.0.100',
        }

      When you want to see the object 'www.apache.org'

      $ puppet connect objects www.apache.org --type host

    DOCS

    arguments '<object_name>'

    when_invoked do |name, options|
      puts 'installing awesome_print gem, improves the output readability.' unless defined?(AwesomePrint::Inspector)
      config_dir = Puppet['confdir']
      type = options.fetch(:type) { /.*/ }
      Hiera.new(:config => "#{config_dir}/hiera.yaml")
      backend = Hiera::Backend::Connect_backend.new
      object_list = backend.lookup_objects(type, name, scope, false, 1)
      output = ''
      object_list.each do |t, o|
        name  = o.keys.first
        value = o.values.first
        output << object_definitions_for(t, name, backend)
        output << object_references_for(t, name, backend)
        output << "#{t}('#{name}') = #{inspect(value)}\n"
      end
      output
    end
  end

  def object_definitions_for(type, name, backend)
    output = ''
    output << "# Object #{type}('#{name}') is defined around:\n"
    backend.object_definitions(type, name).each do |file_name, linenno|
      output << "#   #{file_name}:#{linenno}\n"
    end
    output
  end

  def object_references_for(type, name, backend)
    output = ''
    output << "# Object #{type}('#{name}') is referenced around:\n"
    references = backend.object_references(type, name)
    if !references.empty?
      references.each do |file_name, linenno|
        output << "#   #{file_name}:#{linenno}\n"
      end
    else
      output << "#   not referenced in any connect config file\n"
    end
    output
  end
end
#
# rubocop:enable Metrics/BlockLength
#
