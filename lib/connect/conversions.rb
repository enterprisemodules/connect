require 'connect/entries/object_reference'
require 'connect/extended_array'
require 'method_hash'

module Connect
  module Conversions

    def convert_hash(hash)
      MethodHash[hash.map { |k, v| convert_hash_entry(k, v) }]
    end

    def convert_array(array)
      Connect::ExtendedArray.new(array.map { |e| convert_array_entry(e)})
    end

    def convert_hash_entry(k, v)
      case v
      when Connect::Entry::ObjectReference 
        # TODO: Refacter. This is to difficult
        if v.object_id == k
          key, value = v.final.to_a[0]
          [key, value]
        else
          v.respond_to?(:final) ? [k, v.final] : [k, v]
        end
      when Hash
        [k, convert_hash(v)]
      when Array
        [k, convert_array(v)]
      else
        v.respond_to?(:final) ? [k, v.final] : [k, v]
      end
    end

    def convert_array_entry(v)
      case v
      when Hash
        convert_hash(v)
      when Array
        convert_array(v)
      else
        v.respond_to?(:final) ? v.final : v
      end
    end

  end
end
