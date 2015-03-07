module Connect
  ##
  #
  # This class implements the string interpolator. The string is scanned for values to be interpolated.
  # If they are found, they are replaced with the current values.
  #
  class Interpolator
    #
    # The format of a value that needs to be interpolated
    #
    REGEXP = /(\$\{\s*(?:[a-zA-Z][a-zA-Z0-9_]*::)*[a-zA-Z][a-zA-Z0-9_]*\s*\})/

    def initialize(resolver)
      @resolver = resolver
    end

    ##
    #
    # Look for elements to interpolate and replace them with the actual values
    #
    # @param string [String] the string to be interpolated
    #
    def translate(string)
      variable_strings = string.scan(REGEXP).flatten
      variable_names   = variable_strings.map { |n| n.split(/\{|\}/).last.gsub(/\s+/, '') }
      variable_values  = variable_names.map { |n| @resolver.lookup_value(n).to_s }
      variable_strings.each_index do |index|
        string.gsub!(variable_strings[index], variable_values[index])
      end
      string
    end
  end
end
