require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'

#
# This piece of code is borrowed from Puppet. It creates a valid Puppet scope to
# pass to the Hiera backend. The scope only contains the Facter values.
#
module Scope
  #
  # Main scope method used in values and objects
  # Returns in Puppet way current system scope based on Facter data.
  # Based on this types are created.
  #
  def scope
    set_global_variables

    # Set the facts hash
    # set_facts_hash

    # pretend that the main class (named '') has been evaluated
    # since it is otherwise not possible to resolve top scope variables
    # using '::' when rendering. (There is no harm doing this for the other actions)
    #
    compiler.topscope.class_set('', compiler.topscope)
    scope        = Puppet::Parser::Scope.new(compiler)
    scope.source = Puppet::Resource::Type.new(:node, nodename)
    scope.parent = compiler.topscope
    scope
  end

  # Sets the facts hash
  def set_facts_hash
    compiler.topscope.set_facts(fact_values)
  end

  #
  # Configured trusted data (even if there are none)
  #
  def trusted_data
    compiler.topscope.set_trusted(node.trusted_data)
  end

  #
  # Set all global variables from facts
  #
  def set_global_variables
    fact_values.each { |param, value| compiler.topscope[param] = value }
  end

  #
  # Gets node names from OS.
  #
  def nodename
    Facter.value('hostname')
  end

  #
  # Facter values transformed to hash
  #
  def fact_values
    Facter.to_hash
  end

  #
  # Get node Facter data and transform it to Puppet Node.
  #
  def node
    Puppet::Node.new(nodename, :facts => Puppet::Node::Facts.new('facts', fact_values))
  end

  #
  # Configure compiler with facts and node related data
  #
  def compiler
    Puppet::Parser::Compiler.new(node)
  end
end
