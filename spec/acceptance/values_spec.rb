require 'spec_helper'
require 'dsl/dsl'

RSpec.describe 'setting and retrieving values' do

  let(:dsl) { Dsl.new}

  scopes = ['', 'foo::', 'foo::bar::'].each do |scope|

    context "an integer value width scope '#{scope}'"  do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = 10 
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(10)
      end
    end

    context 'a float value' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = 10.10
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(10.10)
      end
    end

    context 'a boolean value' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = true
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(true)
      end
    end


    context 'a string value' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = 'foo'
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql('foo')
      end
    end

    context 'an array value' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = ['foo','bar']
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(['foo','bar'])
      end
    end

    context 'a hash value' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        #{scope}a = {foo: 'bar'}
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql({:foo =>'bar'})
      end
    end


  end

end

