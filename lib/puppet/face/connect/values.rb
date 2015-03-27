require 'puppet/face'
require 'hiera'
require 'hiera/backend/connect_backend'
begin
  require 'awesome_print'
rescue
  fail 'to use puppet connect values, you must have gem awesome_print loaded'
end



Puppet::Face.define(:connect, '0.0.1') do

  action(:values) do
   default

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

      $ puppet connect values a_value

      To see the value of b_value:

      $ puppet connect values my_scope::b_value

    EOT

    arguments "<variable_name>"

    when_invoked do | name , options| 
      config_dir = Puppet['confdir']
      Hiera.new(:config => "#{config_dir}/hiera.yaml")
      backend = Hiera::Backend::Connect_backend.new
      values_list = backend.lookup_values(name, {}, false, 1)
      output = ''
      values_list.each do | parameter, value|
        output << "#{parameter} = #{value.ai(:indent => 2)}\n"
      end
      output
    end

  end

end

