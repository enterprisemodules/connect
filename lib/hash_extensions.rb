#
# This code is by Avdi Grim. You can find the origin at his blog post
# http://devblog.avdi.org/2009/11/20/hash-transforms-in-ruby/
#
module HashExtensions

  def transform_hash(options={}, &block)
    self.inject({}){|result, (key,value)|
      value = if (options[:deep] && Hash === value) 
        transform_hash(value, options, &block)
      else 
        value
      end
      block.call(result,key,value)
      result
    }
  end
 
  # Convert keys to strings
  def stringify_keys
    transform_hash {|hash, key, value|       
      hash[key.to_s] = value
    }
  end
   
  # Convert keys to strings, recursively
  def deep_stringify_keys
    transform_hash(:deep => true) {|hash, key, value|
      hash[key.to_s] = value
    }                               
  end
end