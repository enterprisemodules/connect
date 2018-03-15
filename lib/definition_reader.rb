require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'

#
# This is definition reader for value and object module.
#
module DefinitionReader
  def definitions_for(parameter, backend)
    output = ''
    output << "# Parameter #{parameter} is defined around:\n"
    backend.value_definitions(parameter).each do |file_name, linenno|
      output << "#   #{file_name}:#{linenno}\n"
    end
    output
  end
end
