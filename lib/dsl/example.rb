$:.unshift('./lib')
require 'dsl/dsl'
require 'byebug'

puts Dsl.parse(<<-EOS)
a = {b=>10, 'c'=>'bert', 1:100, x:{ d:11, e:'hallo'}}
a::b = 10
b = a
name = 'Hallo Bert Hajee'

redirect = name
a::parameter = redirect


include '/Users/hajee/src/hiera-dsl/examples/defaults.config'
EOS