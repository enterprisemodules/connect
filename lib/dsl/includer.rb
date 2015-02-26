class Includer

  DEFAULT_PATH = '/etc/puppet/config/'
  DEFAULT_TYPE = '.config'

	def initialize(config_path = DEFAULT_PATH)
		@config_path  = config_path
		@included_files = []
	end

	def include(name, &proc)
		full_name = Pathname.new(name).absolute? ? name : @config_path + name
		full_name += DEFAULT_TYPE if Pathname.new(full_name).extname == ''
		files = Dir.glob(full_name).each do |file| 
			include_file(file, &proc)
		end
		raise ArgumentError, "No files found for #{name}" if files.empty?
	end

	def included?(name)
		full_name = Pathname.new(name).expand_path.to_s
		@included_files.include?(full_name)
	end

	private

	def include_file(name, &proc)
		unless included?(name)
			register_file(name)
			yield IO.read(name), name
		end
	end

	def register_file(name)
		@included_files << Pathname.new(name).expand_path.to_s
	end


end
