require 'spec_helper'
require 'connect/dsl'

RSpec.describe Connect::Dsl do

  let(:values_table) {Connect::ValuesTable.new}
  let(:objects_table){Connect::ObjectsTable.new}
  let(:interpolator) {Connect::Interpolator.new(values_table)}
  let(:includer)     {Connect::Includer.new}


  let(:dsl) {Connect::Dsl.new( values_table, objects_table, interpolator, includer)}

  describe '#assign' do
    context 'a value' do
      it 'add\'s a value to the value table' do
        expect(Connect::ValuesTable).to receive(:value_entry).with('a',10, nil, nil).and_call_original
        expect(dsl).to receive(:add_value).with('a' => Connect::Entry::Value)
        dsl.assign('a', 10)
      end
    end

    context 'a reference' do
      it 'add\'s a reference to the value table' do
        expect(Connect::ValuesTable).to receive(:value_entry).with('a',Connect::Entry::Reference, nil, nil).and_call_original
        expect(dsl).to receive(:add_value).with('a' => Connect::Entry::Value)
        dsl.assign('a', Connect::Entry::Reference.new('x'))
      end
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
        }.to raise_exception(ArgumentError, 'specified importer \'nonexisting\' doesn\'t exist' )
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
          dsl.define_object('person','bert', nil, {'iterator' => {:from=>1, :to=>20}})
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator without to clause' do
      it 'raises an exception' do
        expect{
          dsl.define_object('person','bert', nil, {'iterator' => {:from=>1, :age=>20}} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator without from clause' do
      it 'raises an exception' do
        expect{
          dsl.define_object('person','bert', nil, {'iterator' => {:to=>20, :age=>20}} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with iterator including invalid clause' do
      it 'raises an exception' do
        expect{
          dsl.define_object('person','bert', nil, {'iterator' => {:from=>1, :go => 'to', :to=>20, :age=>20}} )
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with a definition' do
      it 'add\'s an object to the object table' do
        expect(objects_table).to receive(:add).with('person','bert', {:age=>20}, nil)
        dsl.define_object('person','bert',{:age=>20})
      end
    end

  end

  describe 'object_reference' do

    it 'returns an object_reference ' do
      expect(dsl.reference_object('person','bert')).to be_a(Connect::Entry::ObjectReference)
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

  describe '#double_quoted' do

    context 'no interpolator in string' do
      it 'returns the string' do
        expect(dsl.double_quoted('normal string')).to eq('normal string')
      end
    end

    context 'an interpolator in string' do
      it 'returns an interprolator reference' do
        expect(dsl).to receive(:interpolate).with('${a}',nil)
        dsl.double_quoted('${a}')
      end
    end

  end

  describe '#lookup_values' do

    let(:values_table)  {Connect::ValuesTable.new}
    let!(:value_entry)  {Connect::ValuesTable.value_entry('existing_entry', 'exists') }
    let!(:second_entry) {Connect::ValuesTable.value_entry('second_entry', 'second') }
    let!(:third_entry ) {Connect::ValuesTable.value_entry('third', 'third') }

    before do
      values_table.add(value_entry)
      values_table.add(second_entry)
      values_table.add(third_entry)
    end

    it 'call\'s the value table'  do
      expect(values_table).to receive(:lookup).with('existing_entry')
      expect(values_table).to receive(:lookup).with('second_entry')
      expect(values_table).not_to receive(:lookup).with('third')
      dsl.lookup_values(/.*entry/)
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
