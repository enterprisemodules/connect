require 'connect/entries/object_reference'
require 'connect/extended_array'
require 'method_hash'

module Connect
  #
  # This module converts retrieved data to Puppet digestable form.
  #
  module Conversions
    def convert_hash(hash)
      MethodHash[hash.map { |key, val| convert_hash_entry(key, val) }]
    end

    def convert_array(array)
      Connect::ExtendedArray.new(processed_raw_array(array))
    end

    def processed_raw_array(array)
      array.map { |e| convert_array_entry(e) }
    end

    def convert_hash_entry(key, value)
      case value
      when Connect::Entry::ObjectReference
        return process_matching_value(value) if object_id_equals_key?(value, key)
        final_object(value, key)
      when Hash
        converted_hash(key, value)
      when Array
        converted_array(key, value)
      else
        final_object(value, key)
      end
    end

    def object_id_equals_key?(value, key)
      value.object_id == key
    end

    def converted_hash(key, value)
      [key, convert_hash(value)]
    end

    def converted_array(key, value)
      [key, convert_array(value)]
    end

    def final_object(value, key)
      value.respond_to?(:final) ? [key, value.final] : [key, value]
    end

    def process_matching_value(value)
      key, value = value.final.to_a[0]
      [key, value]
    end

    def convert_array_entry(value)
      case value
      when Hash
        convert_hash(value)
      when Array
        convert_array(value)
      else
        value.respond_to?(:final) ? value.final : value
      end
    end
  end
end
