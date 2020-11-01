require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'

#
# This is reference reader for value and object module.
#
module ReferenceReader
  def references_for(parameter, backend)
    output = ''
    output << "# Parameter #{parameter} is referenced around:\n"
    references = backend.value_references(parameter)
    if references.empty?
      output << "#   not referenced in any connect config file\n"
    else
      references.each do |file_name, linenno|
        output << "#   #{file_name}:#{linenno}\n"
      end
    end
    output
  end
end
