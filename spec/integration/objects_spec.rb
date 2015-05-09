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
      start  = 1
      finish = 10
      foo("bar%d") from start to finish {
        ip:   '20.0.0.%d',
        alias: "foo%d"
      }
      a1 = foo('bar1')
      a2 = foo('bar2')
      a3 = foo('bar3')
      a4 = foo('bar4')
      a5 = foo('bar5')
      a6 = foo('bar6')
      a7 = foo('bar7')
      a8 = foo('bar8')
      a9 = foo('bar9')
      a10 = foo('bar10')
      EOD
      #
      # Check all values
      #
      expect(dsl.lookup_value('a1')).to eql({ 'bar1' => {'ip' => '20.0.0.1', 'alias' =>'foo1'}})
      expect(dsl.lookup_value('a2')).to eql({ 'bar2' => {'ip' => '20.0.0.2', 'alias' =>'foo2'}})
      expect(dsl.lookup_value('a3')).to eql({ 'bar3' => {'ip' => '20.0.0.3', 'alias' =>'foo3'}})
      expect(dsl.lookup_value('a4')).to eql({ 'bar4' => {'ip' => '20.0.0.4', 'alias' =>'foo4'}})
      expect(dsl.lookup_value('a5')).to eql({ 'bar5' => {'ip' => '20.0.0.5', 'alias' =>'foo5'}})
      expect(dsl.lookup_value('a6')).to eql({ 'bar6' => {'ip' => '20.0.0.6', 'alias' =>'foo6'}})
      expect(dsl.lookup_value('a7')).to eql({ 'bar7' => {'ip' => '20.0.0.7', 'alias' =>'foo7'}})
      expect(dsl.lookup_value('a8')).to eql({ 'bar8' => {'ip' => '20.0.0.8', 'alias' =>'foo8'}})
      expect(dsl.lookup_value('a9')).to eql({ 'bar9' => {'ip' => '20.0.0.9', 'alias' =>'foo9'}})
      expect(dsl.lookup_value('a10')).to eql({ 'bar10' => {'ip' => '20.0.0.10', 'alias' =>'foo10'}})
    end
  end



  context 'with a refrence in the attribute' do

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
      foo("foo.${b}") {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = foo('foo.bar.nl')
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end



  context 'as part of an array' do

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

