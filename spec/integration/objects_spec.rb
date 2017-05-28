require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'objects' do

  let(:dsl) { Connect::Dsl.new}

  context 'direct assignment' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      a = foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end


  context 'definition with a variable in the title' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      title = 'foo.bar.nl'
      a = foo(title) {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end


  context 'indirect assignment before definition' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      a = foo('foo.bar.nl')
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end

  context 'indirect assignment with selector before definition' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      a = foo('foo.bar.nl').alias
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql('foo')
    end
  end


  context 'indirect assignment' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = foo('foo.bar.nl')
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end

  context 'indirect assignment with a reference in the title' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      title = 'foo.bar.nl'
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = foo(title)
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end

  context 'definition with iterator' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      start  = '20.0.0.1'
      finish = '20.0.0.9'
      foo('%{name}.connect.com')
        iterate ip from start to finish
        iterate name from 'bar1' to 'bar9'
        iterate interface from 'eth0' to 'eth1' {
        ip:       '%{ip}',
        alias: '%{name}',
        interface: '%{interface}',
      }
      a1 = foo('bar1.connect.com')
      a2 = foo('bar2.connect.com')
      a3 = foo('bar3.connect.com')
      a4 = foo('bar4.connect.com')
      a5 = foo('bar5.connect.com')
      a6 = foo('bar6.connect.com')
      a7 = foo('bar7.connect.com')
      a8 = foo('bar8.connect.com')
      a9 = foo('bar9.connect.com')
      EOD
      #
      # Check all values
      #
      expect(dsl.lookup_value('a1')).to eql({ 'bar1.connect.com' => {'ip' => '20.0.0.1', 'alias' =>'bar1', 'interface' => 'eth0'}})
      expect(dsl.lookup_value('a2')).to eql({ 'bar2.connect.com' => {'ip' => '20.0.0.2', 'alias' =>'bar2', 'interface' => 'eth1'}})
      expect(dsl.lookup_value('a3')).to eql({ 'bar3.connect.com' => {'ip' => '20.0.0.3', 'alias' =>'bar3', 'interface' => 'eth0'}})
      expect(dsl.lookup_value('a4')).to eql({ 'bar4.connect.com' => {'ip' => '20.0.0.4', 'alias' =>'bar4', 'interface' => 'eth1'}})
      expect(dsl.lookup_value('a5')).to eql({ 'bar5.connect.com' => {'ip' => '20.0.0.5', 'alias' =>'bar5', 'interface' => 'eth0'}})
      expect(dsl.lookup_value('a6')).to eql({ 'bar6.connect.com' => {'ip' => '20.0.0.6', 'alias' =>'bar6', 'interface' => 'eth1'}})
      expect(dsl.lookup_value('a7')).to eql({ 'bar7.connect.com' => {'ip' => '20.0.0.7', 'alias' =>'bar7', 'interface' => 'eth0'}})
      expect(dsl.lookup_value('a8')).to eql({ 'bar8.connect.com' => {'ip' => '20.0.0.8', 'alias' =>'bar8', 'interface' => 'eth1'}})
      expect(dsl.lookup_value('a9')).to eql({ 'bar9.connect.com' => {'ip' => '20.0.0.9', 'alias' =>'bar9', 'interface' => 'eth0'}})
    end
  end

  context 'definition with iterator larger then 500 elements' do

    it 'raises an error' do
      expect {
        dsl.parse(<<-EOD)
        foo('%{ip}.connect.com') iterate ip from 1 to 501 {
          ip:       '%{ip}',
        }
        EOD
      }.to raise_error(/elements long, but maximum size is 500/)
    end
  end


  context 'with a reference in the attribute' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      b = 'a reference'
      a = foo("foo.bar.nl") {
        ref:     b,
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ref' => 'a reference'}})
    end
  end

  context 'with a wildcard in the name' do

    context 'without a selector' do
      it 'fetches a set of objects' do
        dsl.parse(<<-EOD)
        foo("a1") { value: 'a1' }
        foo("a2") { value: 'a2' }
        foo("a3") { value: 'a3' }
        foo("b1") { value: 'b1' }
        foo("b2") { value: 'b2' }
        foo("b3") { value: 'b3' }
        bar("a1") { value: 'b3' }
        a = foo(/a./)
        EOD
        expect(dsl.lookup_value('a')).to eql({
          'a1' => {'value' => 'a1'},
          'a2' => {'value' => 'a2'},
          'a3' => {'value' => 'a3'},
        })
      end
    end

    context 'with a selector' do
      it 'fetches a set of objects and applies selector to all' do
        dsl.parse(<<-EOD)
        foo("a1") { value: 'a1' }
        foo("a2") { value: 'a2' }
        foo("a3") { value: 'a3' }
        foo("b1") { value: 'b1' }
        foo("b2") { value: 'b2' }
        foo("b3") { value: 'b3' }
        bar("a1") { value: 'b3' }
        a = foo(/a./)['value']
        EOD
        expect(dsl.lookup_value('a')).to eql({
          'a1' => 'a1',
          'a2' => 'a2',
          'a3' => 'a3'
        })
      end
    end

  end

  context 'with an interpolation in the name of the definition' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      b = 'bar.nl'
      a = foo("foo.${b}") {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end


  context 'with an interpolation in the name of the retrieval' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      b = 'bar.nl'
      foo("foo.bar.nl") {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = foo("foo.${b}")
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end



  context 'as part of an array' do


    context 'in a Hash' do
      it 'is retrievable' do
        dsl.parse(<<-EOD)
        foo('foo.bar.nl') {
          ip:   '10.0.0.100',
          alias: 'foo'
        }
        a = [{a:foo('foo.bar.nl').ip}]
        EOD
        expect(dsl.lookup_value('a')).to eql([{'a' => '10.0.0.100'}])
      end
    end


    context 'without selector' do
      it 'is retrievable' do
        dsl.parse(<<-EOD)
        foo('foo.bar.nl') {
          ip:   '10.0.0.100',
          alias: 'foo'
        }
        a = [foo('foo.bar.nl'),10]
        EOD
        expect(dsl.lookup_value('a')).to eq([{ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}},10])
      end
    end

    context 'with selector' do
      it 'is retrievable' do
        dsl.parse(<<-EOD)
        foo('foo.bar.nl') {
          ip:   '10.0.0.100',
          alias: 'foo'
        }
        a = [foo('foo.bar.nl').ip]
        EOD
        expect(dsl.lookup_value('a')).to eql(['10.0.0.100'])
      end
    end

  end

  context 'as part of an Hash content' do

    it 'is retrievable' do
      dsl.parse(<<-EOD)
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = {'name' => foo('foo.bar.nl')}
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'name' => { 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}}})
    end

  end

  context 'as a Hash entry' do

    it 'is retrievable' do
      dsl.parse(<<-EOD)
      foo('foo') {
        alias: 'foo'
      }
      bar('bar') {
        alias: 'bar'
      }
      a = {foo('foo'), bar('bar'),}
      EOD
      expect(dsl.lookup_value('a')).to eq( { 'foo' => {'alias' =>'foo'}, 'bar' => {'alias' => 'bar'}})
    end

  end


  context 'fetch with single selector' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      b = foo('foo.bar.nl')
      a = b.ip
      EOD
      expect(dsl.lookup_value('a')).to eql('10.0.0.100')
    end
  end

  context 'fetch with multiple selector' do

    it 'is setable and retrievable' do
      dsl.parse(<<-EOD)
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      b = foo('foo.bar.nl').ip
      a = b[0]
      EOD
      if RUBY_VERSION == '1.8.7'
        expect(dsl.lookup_value('a')).to eq(49)
      else
        expect(dsl.lookup_value('a')).to eq('1')
      end
    end
  end

  describe 'autloading an object' do
    it 'exposes the methods' do
      dsl.parse(<<-EOD)
      host('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      hostname = host('foo.bar.nl').hostname
      domain   = host('foo.bar.nl').domain
      fqdn     = host('foo.bar.nl').fqdn
      EOD
      expect(dsl.lookup_value('hostname')).to eql('foo')
      expect(dsl.lookup_value('domain')).to eql('bar.nl')
      expect(dsl.lookup_value('fqdn')).to eql('foo.bar.nl')
    end
  end

end
