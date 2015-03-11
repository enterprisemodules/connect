module Connect
  ##
  #
  # This class implements the functionality to select parts of the current value
  #
  #
  class Selector
    def initialize(value, selector)
      @value = value
      @selection_value = value.respond_to?(:for_selection) ? value.for_selection : value
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
  end
end
