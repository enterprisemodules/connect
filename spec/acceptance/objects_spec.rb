require 'spec_helper'
require 'dsl/dsl'

RSpec.describe 'objects' do

  let(:dsl) { Dsl.new}

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

    it 'is retrievable' do
      dsl.parse(<<-EOD)
      foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      a = [foo('foo.bar.nl'),10]
      EOD
      expect(dsl.lookup_value('a')).to eql([{ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}},10])
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
      expect(dsl.lookup_value('a')).to eql('1')
    end
  end


end

