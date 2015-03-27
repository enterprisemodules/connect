require 'puppet/face'

Puppet::Face.define(:connect, '0.0.1') do

  option "--all", "-a" do
    summary "List all values or objects"
    description <<-EOT
      List all values or objects
    EOT
  end


end

