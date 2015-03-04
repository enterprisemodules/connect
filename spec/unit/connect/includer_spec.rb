require 'spec_helper'
require 'connect/includer'

RSpec.describe Connect::Includer do

	let(:includer) 					{ Connect::Includer.new('./examples/')}
	let(:file_path)					{ 'test1.config' }
	let(:file_path_no_type) { 'test1' }
	let(:wildcard_path)			{ 'test*.config' }
	let(:expanded_path) 		{ Pathname.new('./examples/test1.config').expand_path.to_s}

	describe '#include' do

		context 'a single non existing file' do

			it 'raises an error' do
				expect {
					includer.include('nonexisting_file') {}
				}.to raise_error(ArgumentError)
			end
		end

		context 'a single existing file' do

			it 'registers the file in the included register' do
				includer.include(file_path) {}
				expect(includer.included?(expanded_path)).to be_truthy
			end

			it ' yields the content' do
				expect { |yielder|
					includer.include(file_path, &yielder) 
				}.to yield_with_args("# This is an include file for testing. Don't remove this.", "./examples/test1.config")
			end

		end

		context 'a wild card' do
			it 'yields the content' do
				expect { |yielder|
					includer.include(wildcard_path, &yielder) 
				}.to yield_control.exactly(3).times
			end


			it 'registers all the file in the included register' do
				includer.include(wildcard_path) {}
				expect(includer.included?(expanded_path)).to be_truthy
			end

		end

		context 'an already included file' do
			before do
				includer.include(file_path) {}
			end

			it 'will not be included again' do
				expect { |yielder|
					includer.include(file_path, &yielder)
				}.not_to yield_control

			end

		end

		context 'a file without a type' do

			it 'will default to .config' do
				expect { |yielder|
					includer.include(file_path_no_type, &yielder)
				}.to yield_control.exactly(1).times
			end

		end


	end

end