require 'spec_helper'
require 'connect/values_table'
require 'connect/object_definition'

RSpec.describe Connect::ValuesTable  do

	let!(:table) 					{ Connect::ValuesTable.new()}
	let(:object_value)		{ Connect::ObjectDefinition.new('foo','object_name', {:text => 'exists'})}
	let(:value_entry) 		{ Connect::ValuesTable.value_entry('existing_entry', 'exists') }
	let(:other_entry) 		{ Connect::ValuesTable.value_entry('existing_entry', 'other') }
	let(:connection_entry){ Connect::ValuesTable.connection_entry('connection', 'existing_entry', nil, table)}
	let(:object_entry)		{ Connect::ValuesTable.object_entry('object', object_value)}

	describe '#add' do

		context 'entry not in table' do

			it 'add\'s the entry to the table' do
				table.add(value_entry)
				expect(table.lookup('existing_entry')).to eql 'exists'
			end

		end

		context 'entry exists in table' do

			before do
				table.add(value_entry)
			end

			it 'overwrite\'s the entry to the table' do
				table.add(other_entry)
				expect(table.lookup('existing_entry')).to eql 'other'
			end
		end

	end

	describe '#lookup' do

		context 'for an entry not in table' do

			it 'returns nil' do
				expect(table.lookup('non_existing_name')).to be_nil
			end

		end

		context 'for a value entry' do

			before do
				table.add(value_entry)
			end

			it 'returns the value' do
				expect(table.lookup('existing_entry')).to eql 'exists'
			end
		end

		context 'for a connection' do

				before do
					table.add(connection_entry)
				end

			context 'linking value, exists' do

				before do
					table.add(value_entry)
				end

				it 'returns the value' do
					expect(table.lookup('connection')).to eql 'exists'
				end

			end

			context 'linking value, doesn\'t exists' do

				it 'returns the value' do
					expect(table.lookup('connection')).to be_nil
				end

			end

		end


		context 'for an object' do

			context 'object entry exists' do

				before do
					table.add(object_entry)
				end

				it 'returns the value' do
					expect(table.lookup('object')).to eql({'object_name' => { 'text' => 'exists'}})
				end

				# context 'with a specfied selector' do
				# 	it 'returns the specified part of the value' do
				# 		expect(table.lookup('object','.text')).to eql 'exists'
				# 	end
				# end
			end

			context 'object doesn\'t exists' do

				it 'returns a nill' do
					expect(table.lookup('object')).to be_nil
				end
			end
		end





	end

end