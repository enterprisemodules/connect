require 'puppet/face'

Puppet::Face.define(:connect, '0.0.1') do

  action(:list) do

    summary "List the value(s) specfied in the connect config file(s)"

    description <<-EOT
      List the value(s) specfied in the connect config file(s). If you specfy a parameter name,
      Connect wil show you the specfied name. You can use regular expresion wildcards for the name.       
    EOT

    examples <<-EOT

      Given a connect config file:

        a_value = 10
        my_scope::b_value = a

      When you want to see the value of a_value:

      $ puppet connect list a_value

      To see the value of b_value:

      $ puppet connect list my_scope::b_value

    EOT

    arguments "<variable_name>"

    when_invoked do | name, options| 
      backend = Hiera::Backend::Connect_backend.new
      backend.lookup_values(name, {}, false, 1)
    end


  end

end

