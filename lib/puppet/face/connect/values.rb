require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'
begin
  require 'awesome_print'
rescue LoadError
# Ignore error's in loading these files
end


Puppet::Face.define(:connect, '0.0.1') do

  action(:values) do
   default
    summary "List the value(s) specfied in the connect config file(s)"

    description <<-EOT
      List the value(s) specfied in the connect config file(s). If you specfy a parameter name,
      Connect wil show you the specfied name. You can use regular expresion wildcards for the name.       
    EOT


    option "--all", "-a" do
      summary "List all values"
      description <<-EOT
        List all values
      EOT
    end


    examples <<-EOT

      Given a connect config file:

        a_value = 10
        my_scope::b_value = a

      When you want to see the value of a_value:

      $ puppet connect values a_value

      To see the value of b_value:

      $ puppet connect values my_scope::b_value

    EOT

    arguments "<variable_name>"

    when_invoked do | name , options| 
      unless defined?(AwesomePrint::Inspector)
        puts "installing awesome_print gem, improves the output readability."
      end
      config_dir = Puppet['confdir']
      Hiera.new(:config => "#{config_dir}/hiera.yaml")
      backend = Hiera::Backend::Connect_backend.new
      values_list = backend.lookup_values(name, scope, false, 1)
      output = ''
      values_list.each do | parameter, value|
        output << definitions_for(parameter, backend)
        output << references_for(parameter, backend)
        output << "#{parameter} = #{inspect(value)}\n"
      end
      output
    end

  end

  def definitions_for(parameter, backend)
    output = ''
    output << "# Parameter #{parameter} is defined around:\n"
    backend.value_definitions(parameter).each do | file_name, linenno|
      output << "#   #{file_name}:#{linenno}\n"
    end
    output
  end

  def references_for(parameter, backend)
    output = ''
    output << "# Parameter #{parameter} is referenced around:\n"
    references = backend.value_references(parameter)
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

