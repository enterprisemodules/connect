require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'dsl import' do
  let(:dsl) { Connect::Dsl.new}

  context 'importing' do
    context 'using YAML importer' do
      context 'without scope' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
          import from yaml('./examples/test1.yaml') {
            a = 'existing_entry'
          }
          EOD
          expect(dsl.lookup_value("a")).to eql('this is successfully returned')
        end
      end

      context 'with a scope' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
          import from yaml('./examples/test1.yaml') into imported:: {
            a = 'existing_entry'
          }
          EOD
          expect(dsl.lookup_value("imported::a")).to eql('this is successfully returned')
        end
      end
    end
  end
end
