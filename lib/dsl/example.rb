$:.unshift('./lib')
require 'dsl/dsl'
require 'byebug'

puts Dsl.parse(<<-EOS)

node('bert') from 1 to 100 do
  ip: 10,
  name => ' bert'

end

# a = {b=>10, 'c'=>'bert', 1:100, x:{ d:11, e:'hallo'}}
# a::b = 10
# b = a
# name = 'Hallo Bert Hajee'

# redirect = name
# a::parameter = redirect


# include '/Users/hajee/src/hiera-dsl/examples/defaults.config'
EOS