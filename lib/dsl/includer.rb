class Includer

  DEFAULT_PATH = '/etc/puppet/config/'
  DEFAULT_TYPE = '.config'

	def initialize(config_path = DEFAULT_PATH)
		@config_path  = Pathname.new(config_path)
		@included_files = []
	end

	def include(name, &proc)
		path = Pathname.new(name)
		path = with_extension(path) if no_extension?(path)
		path = with_folder(path) unless path.absolute?
		files = Dir.glob(path).each do |file| 
			include_file(file, &proc)
		end
		raise ArgumentError, "No files found for #{name}" if files.empty?
	end

	def included?(name)
		full_name = Pathname.new(name).expand_path.to_s
		@included_files.include?(full_name)
	end

	def first_file?
		@include_file == []
	end

	private

	def with_folder(path)
		@config_path + path
	end

	def no_extension?(path)
		path.extname == ''
	end

	def with_extension(path)
		Pathname.new(path.to_s + DEFAULT_TYPE)
	end

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
