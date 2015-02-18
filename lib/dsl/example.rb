$:.unshift('./lib')
require 'dsl/dsl'
require 'byebug'

Dsl.parse(<<-EOS)
# a = 10
# a::b = [1]
# a::b = [1,2,3,4,5]
a::b = ['a','b','c','d']

# a::b -> a
# a::parameter -> name
# a::b -> a::c
# include 'a.config'
EOS