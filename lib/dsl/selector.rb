class Selector
	def initialize(value, selector)
		@value 		= value
		@selector = selector
	end

	def execute
	  @value ? instance_eval("@value#{@selector}") : nil
	end

	#
	# Convenience  method
	#
	def self.execute(value, selector)
		instance = self.new(value, selector)
		instance.execute
	end
end
