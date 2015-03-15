require 'spec_helper'
require 'connect/objects_table'
require 'connect/object_definition'

RSpec.describe Connect::ObjectsTable do

	let(:table)  				{Connect::ObjectsTable.new}
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
			it 'return\' an object reference' do
				expect(table.lookup('non-existing', 'dummy')).to eq(Connect::ObjectDefinition.new('non-existing','dummy', {} ))
			end
		end

		context 'object exists' do
			it 'return\'s the object' do
				table.add('person', 'bert', {:age=> 20, :gender => ' male'})
				expect(table.lookup('person', 'bert')).not_to be_nil
			end
		end

	end

	if RUBY_VERSION != '1.8.7'
		#
		# The ommission of Hash ordering, makes these tests fail sometimes
		# We remove them from the 1.8.7 set of tests
		#
		describe '#dump' do

			before do
				table.add('person', 'bert', values)
			end

			it 'writes the content of the objects table in readable format' do
				expect(table.dump()).to eq("person(bert) = {\"age\"=>20, \"gender\"=>\"male\"}\n")
			end
		end
	end


end


