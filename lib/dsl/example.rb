$:.unshift('.')
$:.unshift('../../examples')
require 'dsl'

HieraDsl.define do

  node 'stic%s.is.tribase.nl', :range => 1..10 do
    ip '92.168.130.%s'
  end



  # include_config 'examples/base'

  # network 'stic.is.tribase.nl' do
  #   ip '92.168.130.230'
  # end

  # node 't3dbnode1.development.org' do
  #   ip    '10.100.1.54'
  #   vip   '10.100.1.143'
  #   priv  '10.101.1.54'
  # end

  # node 't3dbnode2.development.org' do
  #   ip    '10.100.1.55'
  #   vip   '10.100.1.145'
  #   priv  '10.101.1.55'
  # end

  db_nodes (1..10).collect {|no| node("stic#{no}.is.tribase.nl")}


  # db_nodes (1..10).collect {|no| node("stic#{no}.is.tribase.nl")}
  #   node('t3dbnode1.development.org'),
  #   node('t3dbnode2.development.org')
  # ]

  # include_config 'base'

  # set "db::node::ip", "10.0.0.100"
  # set "db::node::vip", node('t3dbnode1.development.org').vip
  # set "db::ports", [1,2,3,4,5]
  # connect "test::aa", "db::ports.last"
  # connect "bert::aa", "test::aa"


end
