require 'spec_helper'
require 'dsl/values_table'

RSpec.describe ValuesTable  do

	let(:table) 			{ ValuesTable.new}
	let(:entry) 			{ ValuesTable.entry_for('existing_entry', 'exists') }
	let(:other_entry) 		{ ValuesTable.entry_for('existing_entry', 'other') }

	describe '#add' do

		context 'entry not in table' do

			it 'add\'s the entry to the table' do
				table.add(entry)
				expect(table.lookup('existing_entry')).to eql 'exists'
			end

		end

		context 'entry exists in table' do

			before do
				table.add(entry)
			end

			it 'overwrite\'s the entry to the table' do
				table.add(other_entry)
				expect(table.lookup('existing_entry')).to eql 'other'
			end
		end

	end

	describe '#lookup' do

		context 'entry not in table' do

			it 'returns nil' do
				expect(table.lookup('non_existing_name')).to be_nil
			end
		end

		context 'entry exists in table' do

			before do
				table.add(entry)
			end

			it 'returns the value' do
				expect(table.lookup('existing_entry')).to eql 'exists'
			end
		end
	end

end