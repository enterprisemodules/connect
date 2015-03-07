#
# This code is by Avdi Grim. You can find the origin at his blog post
# http://devblog.avdi.org/2009/11/20/hash-transforms-in-ruby/
#
module HashExtensions
  ##
  #
  # Transform all elements of a hash
  #
  # @param options [Hash] the options for the transform.
  # @param block [Proc] proc to yield
  # @return [Hash] the transformed hash
  #
  # rubocop:disable CaseEquality, ElseAlignment, EndAlignment, IndentationWidth, BlockAlignment, EachWithObject
  def transform_hash(options = {}, &block)
     inject({}) do |result, (key, value)|
      value = if options[:deep] && Hash === value
        transform_hash(value, options, &block)
      else
        value
      end
      block.call(result, key, value)
      result
    end
  end
  # rubocop:enable CaseEquality, ElseAlignment, EndAlignment, IndentationWidth, BlockAlignment, EachWithObject

  #
  # Convert all keys in the hash to strings
  #
  def stringify_keys
    transform_hash do |hash, key, value|
      hash[key.to_s] = value
    end
  end

  # Convert keys to strings, recursively
  def deep_stringify_keys
    transform_hash(:deep => true) do |hash, key, value|
      hash[key.to_s] = value
    end
  end
end
