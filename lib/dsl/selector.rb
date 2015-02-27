class Selector
	def initialize(value, selector)
		if value.class == ObjectEntry && selector
			@value 		= value.to_hash	
		else
			@value 		= value
		end
		@selector = selector
	end

	def run
	  @value ? instance_eval("@value#{@selector}") : nil
	end

	#
	# Convenience  method
	#
	def self.run(value, selector)
		instance = self.new(value, selector)
		instance.run
	end
end
