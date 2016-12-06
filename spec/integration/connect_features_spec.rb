require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'dsl features' do

  let(:dsl)             { Connect::Dsl.instance('./examples')}
  let(:error_config)    { Pathname.new('./examples/error.config').expand_path.to_s}

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
        EOD
        expect(dsl.lookup_value("a")).to eql(true)
      end
    end

    context 'including files' do
      it 'reports errors in the included file' do
        expect {
          dsl.parse(<<-EOD)
          include 'error.config'
          EOD
        }.to raise_error(ParseError, /error\.config/)
      end

      it 'reports errors in the main file after an include' do
        expect {
          dsl.include_file('error_after_include')
        }.to raise_error(ParseError, /error_after_include\.config/)
      end

      it 'processes statements before,in and after include' do
        dsl.parse(<<-EOD)
          before_include = 0
          include 'base'
          after_include = 20
        EOD
        expect(dsl.lookup_value("before_include")).to eq(0)
        expect(dsl.lookup_value("in_include")).to eq(10)
        expect(dsl.lookup_value("after_include")).to eq(20)
      end

      it 'interpolates directly' do
        dsl.parse(<<-EOD)
          a = 'base'
          include "${a}"
          a = 'nobase'
        EOD
        expect(dsl.lookup_value("in_include")).to eq(10)
      end


    end

  end

end
