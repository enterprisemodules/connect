require 'spec_helper'
require 'dsl/dsl'

RSpec.describe Dsl do

  fake(:values_table)
  fake(:objects_table)
  let(:dsl) {Dsl.new( values_table, objects_table, './examples')}

  describe '#assign' do
    it 'add\'s a value to the value table' do
      expect(ValuesTable).to receive(:value_entry).with('a',10).and_call_original
      expect(dsl).to receive(:add_value)
      dsl.assign('a', 10)
    end
  end

  describe '#connect' do
    it 'add\'s a connection to the value table' do
      expect(ValuesTable).to receive(:connection_entry).with('a','b', nil).and_call_original
      expect(dsl).to receive(:add_value)
      dsl.connect('a', 'b')
    end
  end

  describe '#include_file' do

    context 'with a non existing file' do
      it 'raises an error' do
        expect {
          dsl.include_file('no_existing_config')
          }.to raise_error(ArgumentError)
      end
    end

    context ' with an existing file' do
      it 'include\'s a file' do
        expect(dsl).to receive(:scan_str)
        dsl.include_file('test')
      end
    end
  end

  describe '#define' do

    context 'with iterator, but without values' do
      it 'raises an exception' do
        expect{
          dsl.define('person','bert', nil, {:from=>1, :to=>20})
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator without to clause' do
      it 'raises an exception' do
        expect{
          dsl.define('person','bert', {:from=>1},{:age=>20} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator without from clause' do
      it 'raises an exception' do
        expect{
          dsl.define('person','bert', {:to=>20},{:age=>20} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator including invalid clause' do
      it 'raises an exception' do
        expect{
          dsl.define('person','bert', {:from=>1, :go => 'to', :to=>20},{:age=>20} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with a definition' do
      it 'add\'s an object to the object table' do
        expect(objects_table).to receive(:add).with('person','bert', {:age=>20})
        dsl.define('person','bert',{:age=>20})
      end
    end

    context 'without a definition' do
      it 'returns an object from the object table' do
        expect(objects_table).to receive(:lookup).with('person','bert')
        dsl.define('person','bert')
      end
    end


  end

  describe '#add_object' do
    it 'delegates to objects_table' do
      expect(objects_table).to receive(:add).with('person', 'bert', {:age => 20})
      dsl.add_object('person', 'bert', {:age => 20})
    end
  end

  describe '#lookup_object' do
    it 'delegates to objects_table' do
      expect(objects_table).to receive(:lookup).with('person', 'bert')
      dsl.lookup_object('person', 'bert')
    end
  end

  describe '#add_value' do

    let(:entry) { Object.new}

    it 'delegates to values_table' do
      expect(values_table).to receive(:add).with(entry)
      dsl.add_value(entry)
    end
  end

  describe '#lookup_value' do
    it 'delegates to values_table' do
      expect(values_table).to receive(:lookup).with('name')
      dsl.lookup_value('name')
    end
  end

end
