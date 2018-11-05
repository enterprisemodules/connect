require 'connect/object_representation'

module Connect
  ##
  #
  # This class implements the functionality to select parts of the current value
  #
  #
  class Selector
    TO_RESOURCE_REGEX   = /^\.to_resource\('([a-zA-Z]+)'\)/.freeze
    SLICE_REGEX         = /^\.slice\(\s*(['|"]\w*['|"],*\s*)+\)/.freeze
    SLICE_CONTENT_REGEX = /^\.slice_content\(\s*(['|"]\w*['|"],*\s*)+\)/.freeze

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
      return slice_action if @selector && @selection_value

      @value
    end

    def slice_action
      return convert_to_resource if resource?
      return slice_object if puppet_object?
      return slice_content if content?
      return slice_hash if hash?

      instance_eval("@selection_value#{@selector}", __FILE__, __LINE__)
    rescue StandardError => e
      raise ArgumentError, "usage of invalid selector '#{@selector}' on value '#{@selection_value}',
        resulted in Ruby error #{e.message}"
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

    def resource?
      #
      # The to_resource is a special selector when operating on an object. It will transform the
      # object into a valid resource hash and filter all attributes not available in the selected
      # object.
      #
      @selector =~ TO_RESOURCE_REGEX && @value.is_a?(Connect::ObjectRepresentation)
    end

    def puppet_object?
      @selector =~ SLICE_REGEX && @value.is_a?(Connect::ObjectRepresentation)
    end

    def content?
      @selector =~ SLICE_CONTENT_REGEX && @value.is_a?(Connect::ObjectRepresentation)
    end

    def hash?
      @selector =~ SLICE_REGEX && @value.is_a?(Hash)
    end

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
      return {} if items.empty?
      return singlar_hash if items.size == 1

      Hash[@value.select { |key, _value| items.include?(key) }]
    end

    def singlar_hash
      first_item_string if items[0].is_a?(Symbol)
      @value.select { |key| key.to_s.match(items.first) }
    end

    ##
    #
    # filter attributes specified in the arguments.
    #
    # @return [Hash] Resource like hash containing only valid attributes
    #
    def slice_object
      return { object_name => {} } if items.empty?
      return small_object_slice if items.size == 1

      normal_object_slice
    end

    def small_object_slice
      first_item_string if items[0].is_a?(Symbol)
      ObjectRepresentation[object_name, Hash[values.select { |key, _value| key.to_s.match(items.first) }]]
    end

    def first_item_string
      items[0] = items[0].to_s
    end

    def normal_object_slice
      ObjectRepresentation[object_name, Hash[values.select { |key, _value| items.include?(key) }]]
    end

    def slice_content
      return {} if items.empty?
      return small_content_slice if items.size == 1

      Hash[values.select { |key, _value| items.include?(key) }]
    end

    def small_content_slice
      first_item_string if items[0].is_a?(Symbol)
      Hash[values.select { |key, _value| key.to_s.match(items.first) }]
    end

    def values
      @value.values.first
    end

    def items
      @items ||= @selector.scan(/['|"](\w+)['|"]/).flatten
    end

    def object_name
      @value.keys.first
    end
  end
end
