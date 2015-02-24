class Selector
	def initialize(value, selector)
		@value 		= value
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
