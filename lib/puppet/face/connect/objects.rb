require 'puppet/face'

Puppet::Face.define(:connect, '0.0.1') do

  action(:objects) do

    summary "List the objects specfied in the connect config file(s)"

    option "--type OBJECT_TYPE", "-t OBJECT_TYPE" do
      summary "Object type to list"
      description <<-EOT
        Type of objects to list.
      EOT
    end

    description <<-EOT
      List the object(s) specfied in the connect config file(s). If you specfy a parameter name,
      Connect wil show you the specfied object. You can use regular expresion wildcards for the name.       
    EOT

    examples <<-EOT

      Given a connect config file:

        a_value = 10
        my_scope::b_value = a

      When you want to see the value of a_value:

      $ puppet connect objects www.apache.org --type host

    EOT

    arguments "<object_name>"

    when_invoked do | name, options| 
      type = options.fetch(:type) {'.*'}
      backend = Hiera::Backend::Connect_backend.new
      backend.lookup_objects(name, type, {}, false, 1)
    end


  end

end

