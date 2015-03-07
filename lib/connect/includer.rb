module Connect
  ##
  #
  # The Includer class implements the functionality to include other connect config files
  #
  #
  class Includer
    DEFAULT_PATH = '/etc/puppet/config/'  # The default path where to find the config files
    DEFAULT_TYPE = '.config'              # The default file type

    def initialize(config_path = DEFAULT_PATH)
      @config_path  = Pathname.new(config_path)
      @included_files = []
    end

    ##
    #
    # Check the the name of the inclusion and decide what to do. The result(s) will
    # be yielded to the specfied closure. This routine can handle:
    # - absolute file names without wildcards
    # - absolute file names with a wildcard
    # - relative file names without wildcards
    # - relative file names with a wildcard
    #
    # If a file extention is not givcen, it will use the default_type
    #
    # @param [String] name the file name.
    # @param [Proc] proc the closure to be yielded.
    #
    # @yieldparam [String] name The name of the file to be included
    # @yieldparam [String] content The actual content of the file to be included
    #
    def include(name, &proc)
      path = Pathname.new(name)
      path = with_extension(path) if no_extension?(path)
      path = with_folder(path) unless path.absolute?
      files = Dir.glob(path).each do |file|
        include_file(file, &proc)
      end
      fail ArgumentError, "No files found for #{name}" if files.empty?
    end

    ##
    #
    # Check if the specfied file is already included or not
    #
    # @param [String] name the file name to be checked
    # @return [Bool] true when the  file is already included
    def included?(name)
      full_name = Pathname.new(name).expand_path.to_s
      @included_files.include?(full_name)
    end

    #
    # Check if the includer has already included files or not
    #
    # @return [Bool] true if we didn't include any other files yet.
    #
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

    # rubocop:disable GuardClause
    def include_file(name)
      unless included?(name)
        register_file(name)
        yield(IO.read(name), name)
      end
    end
    # rubocop:enable GuardClause

    ##
    #
    # Register the file in the included file list
    #
    # @param [String] name of the file to register
    #
    def register_file(name)
      @included_files << Pathname.new(name).expand_path.to_s
    end
  end
end
