$:.unshift('./lib')
require 'dsl/dsl'
require 'byebug'

puts Dsl.parse(<<-EOS)
a = {b=>10, 'c'=>'bert', 1:100, x:{ d:11, e:'hallo'}}
EOS