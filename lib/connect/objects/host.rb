require 'connect/entries/object'

module Connect
  #
  # This module is the host of all implementations of ObjectDefinitions.
  #
  module Objects
    ##
    #
    # Implements a object_type host. It add's some automagic attributes like:
    # hostname
    # domain
    # fqdn
    #
    class Host < Connect::ObjectDefinition
      def initialize(type, name, data)
        super(type, name, data)
        self['hostname'] = name.split('.').first
        self['domain']   = name.split('.')[-2..-1].join('.')
        self['fqdn']     = name
      end
    end
  end
end
