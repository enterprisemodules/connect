require 'connect/object_representation'

module Connect
  ##
  #
  # This class implements the functionality to select parts of the current value
  #
  #
  class Selector
    TO_RESOURCE_REGEX   = /^\.to_resource\('([a-zA-Z]+)'\)/
    SLICE_REGEX         = /^\.slice\(\s*(['|"]\w*['|"],*\s*)+\)/
    SLICE_CONTENT_REGEX = /^\.slice_content\(\s*(['|"]\w*['|"],*\s*)+\)/

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
          case
          when @selector =~ TO_RESOURCE_REGEX && @value.is_a?(Connect::ObjectRepresentation)
            #
            # The to_resource is a special selector when operating on an object. It will transform the
            # object into a valid resource hash and filter all attributes not available in the selected
            # object.
            #
            convert_to_resource
          when @selector =~ SLICE_REGEX && @value.is_a?(Connect::ObjectRepresentation)
            slice_object
          when @selector =~ SLICE_CONTENT_REGEX && @value.is_a?(Connect::ObjectRepresentation)
            slice_content
          when @selector =~ SLICE_REGEX && @value.is_a?(Hash)
            slice_hash
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
    ##
    #
    # remove all attributes thar do not belong to the specified resource
    #
    # @return [Hash] Resource like hash containing only valid attributes
    #
    def slice_hash
      items = @selector.scan(/['|"](\w+)['|"]/).flatten
      return {} if items.empty?
      if items.size == 1
        items[0] = items[0].to_s if items[0].is_a?(Symbol)
        @value.select {|key| key.to_s.match(items.first) }
      else
        Hash[@value.select {|key, value| items.include?(key)}]
      end
    end
    ##
    #
    # filter attributes specified in the arguments.
    #
    # @return [Hash] Resource like hash containing only valid attributes
    #
    def slice_object
      object_name = @value.keys.first
      values = @value.values.first
      items = @selector.scan(/['|"](\w+)['|"]/).flatten
      return {object_name => {}} if items.empty?
      if items.size == 1
        items[0] = items[0].to_s if items[0].is_a?(Symbol)
        ObjectRepresentation[object_name, Hash[values.select {|key, value| key.to_s.match(items.first) }]]
      else
        ObjectRepresentation[object_name, Hash[values.select {|key, value| items.include?(key)}]]
      end
    end


    def slice_content
      values = @value.values.first
      items = @selector.scan(/['|"](\w+)['|"]/).flatten
      return {} if items.empty?
      if items.size == 1
        items[0] = items[0].to_s if items[0].is_a?(Symbol)
        Hash[values.select {|key, value| key.to_s.match(items.first) }]
      else
        Hash[values.select {|key, value| items.include?(key)}]
      end
    end

  end
end
