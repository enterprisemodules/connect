class Interpolator

  REGEXP = /(\$\{\s*(?:[a-zA-Z][a-zA-Z0-9]*::)*[a-zA-Z][a-zA-Z0-9]*\s*\})/

	def initialize( resolver)
		@resolver = resolver
	end

	def translate(string)
		variable_strings = string.scan(REGEXP).flatten
		variable_names   = variable_strings.map {|n| n.split(/\{|\}/).last.gsub(/\s+/, "")}
		variable_values  = variable_names.map {|n| @resolver.lookup_value(n).to_s}
		variable_strings.each_index do | index| 
			string.gsub!(variable_strings[index], variable_values[index])
		end
		string
	end

end
