require 'spec_helper'
require 'dsl/objects_table'

RSpec.describe ObjectsTable do

	let(:table)  				{ObjectsTable.new}
	let(:values) 				{{:age=> 20, :gender => 'male'}}
	let(:other_values)  {{:age=> 19, :gender => 'female'}}

	describe '#add' do 

		context 'object doesn\'t exist yet' do
			it 'add\'s the object to the table' do
				table.add('person', 'bert', values)
				expect(table.lookup('person', 'bert')).not_to be_nil
			end
		end

		context 'object already exists' do
			before do
				table.add('person', 'bert', values)
			end

			it 'updates the object to the table' do
				table.add('person', 'bert', other_values)
				expect(table.lookup('person', 'bert').age).to eql 19
			end
		end

	end

	describe '#lookup' do 

		context 'object doesn\'t exist' do
			it 'return\' nil' do
				expect(table.lookup('non-existing', 'dummy')).to be_nil
			end
		end

		context 'object exists' do
			it 'return\'s the object' do
				table.add('person', 'bert', {:age=> 20, :gender => ' male'})
				expect(table.lookup('person', 'bert')).not_to be_nil
			end
		end

	end


end


