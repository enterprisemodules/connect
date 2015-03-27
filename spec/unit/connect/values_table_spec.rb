require 'spec_helper'
require 'connect/values_table'
require 'connect/objects_table'
require 'connect/object_definition'
require 'connect/dsl'

RSpec.describe Connect::ValuesTable  do

	let!(:values_table) 						{ Connect::ValuesTable.new()}
	let!(:objects_table) 						{ Connect::ObjectsTable.new()}

	let!(:value_entry) 							{ Connect::ValuesTable.value_entry('existing_entry', 'exists') }
	let!(:second_entry) 						{ Connect::ValuesTable.value_entry('second_entry', 'second') }
	let!(:third_entry ) 						{ Connect::ValuesTable.value_entry('third', 'third') }
	let!(:selected_value_entry) 		{ Connect::ValuesTable.value_entry('existing_entry', 'exists', '[0,3]') }
	let!(:other_entry) 							{ Connect::ValuesTable.value_entry('existing_entry', 'other') }
	let!(:reference_entry)					{ Connect::ValuesTable.reference_entry('reference', 'existing_entry')}
	let!(:sel_ref_ref)							{ Connect::ValuesTable.reference_entry('reference2', 'reference', '[0,2]')}
	let!(:selected_reference_entry)	{ Connect::ValuesTable.reference_entry('reference', 'existing_entry', '[0,3]')}

	let(:object_reference_entry) 		{ Connect::ValuesTable.object_reference_entry('object_reference', 'object_type', 'object_name') }
	let(:sel_object_reference_entry){ Connect::ValuesTable.object_reference_entry('object_reference', 'object_type', 'object_name', '.text') }

	before do
		Connect::Entry::Base.values_table  = values_table
		Connect::Entry::Base.objects_table = objects_table
		objects_table.add('object_type','object_name', {:text => 'exists'})
	end

	describe '#entries' do

		context 'values table is empty' do

			it 'returns an empty array ' do
				expect(values_table.entries).to eq([])
			end
		end

		context 'values table contains elements' do

			before do
				values_table.add(value_entry)
				values_table.add(second_entry)
				values_table.add(third_entry)
			end

			context 'with an existing entry' do
				context 'without arguments' do
					it 'returns an array of all variable names' do
						expect(values_table.entries).to eq(['existing_entry','second_entry', 'third'])
					end
				end

				context 'with a string argument' do
					it 'returns an array with the selected variable name' do
						expect(values_table.entries('third')).to eq(['third'])
					end
				end

				context 'with a wildcard argument' do
					it 'returns an array of the the selected variable names' do
						expect(values_table.entries(/.*entry/)).to eq(['existing_entry','second_entry'])
					end
				end
			end

			context 'with a non exiting variable' do
				it 'returns an empty array' do
					expect(values_table.entries('non_existing')).to eq([])
				end
			end

		end

	end

	describe '#add' do

		context 'entry doesn\'t exists' do
			context 'a value' do

				it 'add\'s a value to the table' do
					values_table.add(value_entry)
					expect(values_table.entries).to include('existing_entry')
					expect(values_table.entries).to have_exactly(1).items
				end

			end

			context 'a reference' do

				before do
					values_table.add(value_entry)
				end

				it 'add\'s an object reference to the table' do
					values_table.add(reference_entry)
					expect(values_table.entries).to include('reference')
					expect(values_table.entries).to have_exactly(2).items
				end

			end

			context 'an object' do

				it 'add\'s a reference to the table' do
					values_table.add(object_reference_entry)
					expect(values_table.entries).to include('object_reference')
					expect(values_table.entries).to have_exactly(1).items
				end
			end

		end

		context 'entry already exists' do

			before do
				values_table.add(value_entry)
			end


			it 'ovewrites the entry in the table' do
				values_table.add(other_entry)
				expect(values_table.entries).to include('existing_entry')
				expect(values_table.entries).to have_exactly(1).items
			end

		end
	end


	describe '#lookup' do

		context 'without selector' do
			context 'for an entry not in table' do

				it 'returns nil' do
					expect(values_table.lookup('non_existing_name')).to be_nil
				end

			end

			context 'for a value entry' do

				before do
					values_table.add(value_entry)
				end

				it 'returns the value' do
					expect(values_table.lookup('existing_entry')).to eql 'exists'
				end
			end

			context 'for a connection' do

					before do
						values_table.add(reference_entry)
					end

				context 'linking value, exists' do

					before do
						values_table.add(value_entry)
					end

					it 'returns the value' do
						expect(values_table.lookup('reference')).to eql 'exists'
					end

				end

				context 'linking value, doesn\'t exists' do

					it 'returns nil' do
						expect(values_table.lookup('connection')).to be_nil
					end

				end

			end

			context 'for an object' do


				context 'object value, exists' do

					before do
						values_table.add(object_reference_entry)
					end

					it 'returns the value' do
						expect(values_table.lookup('object_reference')).to eql({'object_name' =>{'text' => 'exists'}})
					end

				end

				context 'object value, doesn\'t exists' do

					it 'returns nil' do
						expect(values_table.lookup('object_reference')).to be_nil
					end

				end

			end



		end


		context 'with a selector' do

			context 'for a value entry' do

				before do
					values_table.add(selected_value_entry)
				end

				it 'returns the value' do
					expect(values_table.lookup('existing_entry')).to eql 'exi'
				end
			end

			context 'for a connection' do

				before do
					values_table.add(selected_reference_entry)
					values_table.add(value_entry)
				end

				context 'single one' do

					it 'returns the value' do
						expect(values_table.lookup('reference')).to eql 'exi'
					end

				end

				context 'for a multiple single connection' do

					before do
						values_table.add(sel_ref_ref)
					end

					it 'returns the value' do
						expect(values_table.lookup('reference2')).to eql 'ex'
					end

				end
			end


			context 'for an object' do

				before do
					values_table.add(sel_object_reference_entry)
				end

				it 'returns the value' do
					expect(values_table.lookup('object_reference')).to eql('exists')
				end
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
				dsl = Connect::Dsl.new(values_table)
				dsl.parse(<<-EOD)
				a = 10
				b = foo('bar')
				c = b
				d = a
				EOD
			end

			it 'dumps the content of the values table' do
				expect(values_table.dump).to eq("a = 10\nb = {\"bar\"=>{}}\nc = {\"bar\"=>{}}\nd = 10\n")
			end
		end
	end

end