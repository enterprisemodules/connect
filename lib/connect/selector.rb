require 'connect/object_representation'

module Connect
  ##
  #
  # This class implements the functionality to select parts of the current value
  #
  #
  class Selector
    TO_RESOURCE_REGEX = /\.to_resource\('([a-zA-Z]+)'\)/

    def initialize(value, selector)
      @value = value
      @selection_value = convert(value)
      @selector = selector
    end

    ##
    #
    # apply the current selector on the current value
    #
    # @return the new value
    # rubocop:disable PerceivedComplexity
    def run
      if @selector && @selection_value
        begin
          if @selector =~ TO_RESOURCE_REGEX && @value.is_a?(Connect::ObjectRepresentation)
            #
            # The to_resource is a special selector when operating on an object. It will transform the
            # object into a valid resource hash and filter all attributes not available in the selected
            # object.
            #
            convert_to_resource
          else
            instance_eval("@selection_value#{@selector}")
          end
        rescue => e
          raise ArgumentError, "usage of invalid selector '#{@selector}' on value '#{@selection_value}',
            resulted in Ruby error #{e.message}"
        end
      else
        @value
      end
    end
    # rubocop:enable PerceivedComplexity

    #
    # Convenience  method
    #
    # @param value [Any] The current value
    # @param selector [String] the selector to be applied
    # @return a new value
    def self.run(value, selector)
      instance = new(value, selector)
      instance.run
    end

    private

    ##
    #
    # To make sure all ObjectRepresentations are transformed to their values
    # before selection. Convert them all
    #
    # @param value [Any] The value to convert
    #
    def convert(value)
      case value
      when Array
        #
        # Because we've defined some convinieance methods for Array's, we
        # force the return value to be of type ExtendedArray
        #
        Connect::ExtendedArray.new(value.map { |e| transform(e) })
        # when Hash
        #   #
        #   # Because we've defined some conveniance methods for Hashes, we force
        #   # the type to be a MathodHash
        #   #
        #   MethodHash[@value.map { |k, v| [k, transform(v)]}]
      else
        transform(value)
      end
    end

    def transform(value)
      value.is_a?(Connect::ObjectRepresentation) ? value.value : value
    end

    ##
    #
    # remove all attributes thar do not belong to the specified resource
    #
    # @return [Hash] Resource like hash containing only valid attributes
    #
    def convert_to_resource
      resource_type = @selector.scan(TO_RESOURCE_REGEX).flatten.first
      resource = Puppet::Type.type(resource_type)
      all_attributes = resource.allattrs.collect(&:to_s)
      cleaned_value = @value.value.collect { |k, v| all_attributes.include?(k) ? [k, v] : nil }.compact
      { @value.keys.first => Hash[cleaned_value] }
    end
  end
end
