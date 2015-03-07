require 'spec_helper'
require 'connect/datasources/yaml'

RSpec.describe Connect::Datasources::Yaml do

  Yaml = described_class

  let(:file_path)         { 'test1.yaml' }
  let(:expanded_path)     { Pathname.new('./examples/test1.yaml').expand_path.to_s}
  let(:datasource)        { Yaml.new( 'yaml', expanded_path)}

  describe '#initialize' do
    context 'with a non existing file' do
      it 'raises an error' do
        expect {
          Yaml.new('yaml', 'nonexisting.file')
        }.to raise_error(Errno::ENOENT)
      end
    end

    context 'with a full path name' do
      it 'opens the file and read\'s it' do
        expect(YAML).to receive(:load_file).with(expanded_path)
        Yaml.new('yaml', expanded_path )
      end
    end
  end


  describe "#lookup" do

    context 'with an existing entry' do
      it 'returns the value' do
        expect(datasource.lookup('existing_entry')).to eq 'this is succesfully returned'
      end
    end

    context 'with a non existing entry' do
      it 'returns a nil' do
        expect(datasource.lookup('non_existing_entry')).to be_nil
      end
    end


  end

end

