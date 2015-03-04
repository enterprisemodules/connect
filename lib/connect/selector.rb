module Connect
	class Selector
		def initialize(value, selector)
			@value = value
			@selection_value = value.respond_to?(:for_selection) ? value.for_selection : value
			@selector = selector
		end

		def run
			if @selector && @selection_value
				instance_eval("@selection_value#{@selector}")
			else
				@value
			end
		end

		#
		# Convenience  method
		#
		def self.run(value, selector)
			instance = self.new(value, selector)
			instance.run
		end

	end
end