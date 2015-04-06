require 'puppet/face'

Puppet::Face.define(:connect, '0.0.1') do

  action(:objects) do

    summary "List the objects specfied in the connect config file(s)"

    option "--type OBJECT_TYPE", "-t OBJECT_TYPE" do
      summary "Object type to list"
      description <<-EOT
        Type of objects to list.
      EOT
    end

    description <<-EOT
      List the object(s) specfied in the connect config file(s). If you specfy a parameter name,
      Connect wil show you the specfied object. You can use regular expresion wildcards for the name.       
    EOT

    examples <<-EOT

      Given a connect config file:

        a_value = 10
        my_scope::b_value = a

      When you want to see the value of a_value:

      $ puppet connect objects www.apache.org --type host

    EOT

    arguments "<object_name>"

     when_invoked do | name , options| 
      unless defined?(AwesomePrint::Inspector)
        puts "installing awesome_print gem, improves the output readability."
      end
      config_dir = Puppet['confdir']
      type = options.fetch(:type) {/.*/}
      Hiera.new(:config => "#{config_dir}/hiera.yaml")
      backend = Hiera::Backend::Connect_backend.new
      object_list = backend.lookup_objects(type, name, scope, false, 1)
      output = ''
      object_list.each do | type, object |
        name = object.keys.first
        value = object.values.first
        output << object_definitions_for(type, name, backend)
        output << object_references_for(type, name, backend)
        output << "#{type}('#{name}') = #{inspect(value)}\n"
      end
      output
    end

  end

  def object_definitions_for(type, name, backend)
    output = ''
    output << "# Object #{type}('#{name}') is defined around:\n"
    backend.object_definitions(type, name).each do | file_name, linenno|
      output << "#   #{file_name}:#{linenno}\n"
    end
    output
  end

  def object_references_for(type,name, backend)
    output = ''
    output << "# Object #{type}('#{name}') is referenced around:\n"
    references = backend.object_references(type, name)
    if references.length > 0
      references.each do | file_name, linenno|
        output << "#   #{file_name}:#{linenno}\n"
      end
    else
      output <<   "#   not referenced in any connect config file\n"
    end
    output
  end

  #
  # This piece of copde is borrowed from Puppet. It create'a a valid Puppet scope to pass
  # to the hier backend. The scope only contains the facter values. 
  #
  def scope
    nodename = Facter.value('hostname')
    fact_values = Facter.to_hash
    node = Puppet::Node.new(nodename, :facts => Puppet::Node::Facts.new("facts", fact_values))
    compiler = Puppet::Parser::Compiler.new(node)
    # configure compiler with facts and node related data
    # Set all global variables from facts
    fact_values.each {|param, value| compiler.topscope[param] = value }
    # Configured trusted data (even if there are none)
    compiler.topscope.set_trusted(node.trusted_data)
    # Set the facts hash
    # compiler.topscope.set_facts(fact_values)

    # pretend that the main class (named '') has been evaluated
    # since it is otherwise not possible to resolve top scope variables
    # using '::' when rendering. (There is no harm doing this for the other actions)
    #
    compiler.topscope.class_set('', compiler.topscope)
    scope = Puppet::Parser::Scope.new(compiler)
    scope.source = Puppet::Resource::Type.new(:node, nodename)
    scope.parent = compiler.topscope
    scope
  end

  def inspect(value)
    if defined?(AwesomePrint::Inspector)
      value.ai(:indent => 2)
    else
      value.inspect
    end
  end


end

