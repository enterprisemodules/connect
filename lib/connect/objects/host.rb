require 'connect/entries/object'

module Connect
  module Objects
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
