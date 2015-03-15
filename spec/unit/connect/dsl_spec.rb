require 'spec_helper'
require 'connect/dsl'
require 'connect/datasources/yaml'

RSpec.describe Connect::Dsl do

  if defined?(Bogus)
    fake(:values_table) {Connect::ValuesTable}
    fake(:objects_table){Connect::ObjectsTable}
    fake(:interpolator) {Connect::Interpolator}
    fake(:includer)     {Connect::Includer}
  else
    let(:values_table) {Connect::ValuesTable.new}
    let(:objects_table){Connect::ObjectsTable.new}
    let(:interpolator) {Connect::Interpolator.new(values_table)}
    let(:includer)     {Connect::Includer.new}
  end

  let(:dsl) {Connect::Dsl.new( values_table, objects_table, interpolator, includer)}

  describe '#assign' do
    it 'add\'s a value to the value table' do
      expect(Connect::ValuesTable).to receive(:value_entry).with('a',10, nil).and_call_original
      expect(dsl).to receive(:add_value)
      dsl.assign('a', 10)
    end
  end

  describe '#connect' do
    it 'add\'s a connection to the value table' do
      expect(Connect::ValuesTable).to receive(:connection_entry).with('a','b', nil, values_table).and_call_original
      expect(dsl).to receive(:add_value)
      dsl.connect('a', 'b')
    end
  end

  describe '#include_file' do
    it 'include\'s a file' do
      expect(includer).to receive(:include)
      dsl.include_file('test')
    end
  end


  describe '#datasource' do
    context "importer exists" do
      it 'instantiate\'s the importer' do
        expect(Connect::Datasources::Yaml).to receive(:new).with('yaml', 'a.yaml')
         dsl.datasource('yaml', 'a.yaml')
      end
    end

    context "importer does not exists" do
      it 'passes control to the importer' do
        expect {
         dsl.datasource('nonexisting', 'a.yaml')
        }.to raise_exception(ArgumentError, 'specfied importer \'nonexisting\' doesn\'t exist' )
      end
    end

  end

  describe '#import' do

    let(:yaml_file) {Pathname.new('./examples/test1.yaml').expand_path.to_s}

    before do
      dsl.datasource('yaml', yaml_file)
    end

    it 'call\'s the importer' do
      expect_any_instance_of(Connect::Datasources::Yaml).to receive(:lookup).with('lookup')
       dsl.import('value', 'lookup')
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
        expect(objects_table).to receive(:lookup).with('person','bert').and_call_original
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

  describe '#interpolate' do

    it 'replaces the variable with their values at compile time' do
      expect(interpolator).to receive(:translate).with('${foo::bar} is ${value}')
      dsl.interpolate('${foo::bar} is ${value}')
    end

  end


  describe '#dump_objects' do
    it 'asks the objects table to fump itself' do
      expect(objects_table).to receive(:dump)
      dsl.dump_objects
    end
  end

  describe '#dump_values' do
    it 'asks the values table to dump itself' do
      expect(values_table).to receive(:dump)
      dsl.dump_values
    end
  end


end
