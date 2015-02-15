# encoding: UTF-8
module ConfigIncluder
  # @private
  def self.included(parent)
    parent.extend(ConfigIncluder)
  end
  ##
  #
  # This is an implementation of a C like include. You can use this at
  # places where Puppet doesn't support parent-classed like when defining
  # Custum Types. include_file uses the already established search path.
  # If you need to include a file from a subdirectory, use the subdirectory
  # name
  #
  # @example
  #
  #  include_file 'puppet/types/ora'
  #
  # @param name [String] this is the name of the file to be included
  # @raise [ArgumentError] when the specified file is not found
  # @return the evaluated content of the file
  #
  #
  def include_config(name)
    full_name = get_ruby_file(name)
    fail ArgumentError, "config file #{name} not found" unless full_name
    eval(IO.read(full_name), nil, full_name)
  end

  private

  # @private
  def get_ruby_file(name)
    name = Pathname(name)
    return name.to_s if name.absolute?
    name = Pathname.new(name.to_s + '.config') unless name.extname == '.config'
    name = name.to_s
    path = $LOAD_PATH.find { |dir|File.exist?(File.join(dir, name)) }
    path && File.join(path, name)
  end
end
