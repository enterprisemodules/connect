$:.unshift('./lib')
require 'dsl/dsl'
require 'byebug'

Dsl.parse(<<-EOS)
# Comment
a::b = 10.5
a::b = 10.5
a::b = 10.5
a::b = 10.5
a::b -> a
a::b -> a::c
include 'a.config'
EOS