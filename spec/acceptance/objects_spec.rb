require 'spec_helper'
require 'dsl/dsl'

RSpec.describe 'objects' do

  let(:dsl) { Dsl.new}

  context 'direct assignment' do

    it 'is settable and retrievable' do
      dsl.parse(<<-EOD)
      a = foo('foo.bar.nl') {
        ip:   '10.0.0.100',
        alias: 'foo'
      }
      EOD
      expect(dsl.lookup_value('a')).to eql({ 'foo.bar.nl' => {'ip' => '10.0.0.100', 'alias' =>'foo'}})
    end
  end


  context 'indirect assignment' do

    it 'is settable and retrievable' do
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

  # context 'fetch with selector' do

  #   it 'is settable and retrievable' do
  #     dsl.parse(<<-EOD)
  #     foo('foo.bar.nl') {
  #       ip:   '10.0.0.100',
  #       alias: 'foo'
  #     }
  #     b = foo('foo.bar.nl')
  #     a = b.ip
  #     EOD
  #     expect(dsl.lookup_value('a')).to eql('10.0.0.100')
  #   end
  # end


end

