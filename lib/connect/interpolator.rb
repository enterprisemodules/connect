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
    CONNECT_REGEXP = /(\$\{\s*(?:[a-zA-Z][a-zA-Z0-9_]*::)*[a-zA-Z][a-zA-Z0-9_\.\:\&\[\]\'\(\),]*\s*\})/
    PUPPET_REGEXP = /(\%\{\s*(?:::)?(?:[a-zA-Z][a-zA-Z0-9_]::)*[a-zA-Z][a-zA-Z0-9_]*\s*\})/

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
      string = interpolate_connect_variables(string)
      interpolate_puppet_variables(string)
    end

    private

    def interpolate_connect_variables(string)
      variable_strings = string.scan(CONNECT_REGEXP).flatten
      variable_names   = variable_strings.map { |n| n.split(/\{|\}/).last.gsub(/\s+/, '') }
      variable_values  = variable_names.map { |n| connect_interpolate(n) }
      variable_strings.each_index do |index|
        string.gsub!(variable_strings[index], variable_values[index])
      end
      string
    end

    def interpolate_puppet_variables(string)
      variable_strings = string.scan(PUPPET_REGEXP).flatten
      variable_names   = variable_strings.map { |n| n.split(/\{|\}/).last.gsub(/\s+/, '') }
      variable_values  = variable_names.map { |n| puppet_interpolate(n) }
      variable_strings.each_index do |index|
        string.gsub!(variable_strings[index], variable_values[index])
      end
      string
    end

    private

    def connect_interpolate(variable)
      variable, selector = variable.split(/([\[\.].*)/)
      value = @resolver.lookup_value(variable)
      Selector.run(value, selector).to_s
    end

    def puppet_interpolate(variable)
      if Connect::Dsl.config.scope.nil?
        ''
      else
        Connect::Dsl.config.scope[variable].to_s
      end
    end
  end
end
