require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'dsl features' do

  let(:dsl) { Connect::Dsl.new}

  context 'calculating values' do

    context 'adding' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        a = 1 + 2
        EOD
        expect(dsl.lookup_value("a")).to eql(3)
      end
    end

    context 'subtracting' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        a = 1 - 2
        EOD
        expect(dsl.lookup_value("a")).to eql(-1)
      end
    end

    context 'multiplying' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        a = 2 * 2
        EOD
        expect(dsl.lookup_value("a")).to eql(4)
      end
    end

    context 'dividing' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        a = 8 / 2
        EOD
        expect(dsl.lookup_value("a")).to eql(4)
      end
    end

    context 'or-ing' do
      it 'is settable and retrievable' do
        dsl.parse(<<-EOD)
        a = true or false
        # expect(dsl.lookup_value("a")).to eql(false)
        EOD
        expect(dsl.lookup_value("a")).to eql(true)
        # expect(dsl.lookup_value("b")).to eql(false)
      end
    end


  end

end

