require 'spec_helper'
require 'dsl/dsl'

RSpec.describe 'connecting retrieving values' do

  let(:dsl) { Dsl.new}

  scopes = ['', 'foo::'].each do |scope|

    context "variable defined before, using scope #{scope}" do
      it 'retrieve returns a nil' do
        dsl.parse(<<-EOD)
        c = 10
        #{scope}a = c
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(10)
      end
    end

    context "variable defined after, using scope #{scope}" do
      it 'retrieve returns a nil' do
        dsl.parse(<<-EOD)
        #{scope}a = c
        c = 10
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(10)
      end
    end

    context "variable doesn't exist, using scope #{scope}" do
      it 'retrieve returns a nil' do
        dsl.parse(<<-EOD)
        #{scope}a = c
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(nil)
      end
    end

    context "variable defined before, target is a connection, using scope #{scope}" do
      it 'retrieve returns a nil' do
        dsl.parse(<<-EOD)
        x = 4
        c = x
        #{scope}a = c
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(4)
      end
    end

    context "variable defined later, target is a connection, using scope #{scope}" do
      it 'retrieve returns a nil' do
        dsl.parse(<<-EOD)
        c = x
        #{scope}a = c
        x = 4
        EOD
        expect(dsl.lookup_value("#{scope}a")).to eql(4)
      end
    end


  end

end

