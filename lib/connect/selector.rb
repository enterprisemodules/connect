require 'connect/object_representation'

module Connect
  ##
  #
  # This class implements the functionality to select parts of the current value
  #
  #
  class Selector
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
    def run
      if @selector && @selection_value
        begin
          instance_eval("@selection_value#{@selector}")
        rescue => e
          raise ArgumentError, "usage of invalid selector '#{@selector}' on value '#{@selection_value}', resulted in Ruby error #{e.message}"
        end
      else
        @value
      end
    end

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

  end
end
