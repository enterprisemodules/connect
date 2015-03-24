require 'spec_helper'
require 'connect/interpolator'
require 'connect/dsl'

RSpec.describe Connect::Interpolator do

  let(:dsl) {Connect::Dsl.new()}
  let(:interpolator) {dsl.interpolator}

	before do
		dsl.assign('name', 'James')
		dsl.assign('scope::number', 10)
		dsl.assign('struct', MethodHash['first_part', [10,20,'hello John']])
	end

	describe '#translate' do

		context 'with a direct variable name' do

			context 'a string with valid connect interpolation' do
				it 'returns an interpolated string' do
					expect(interpolator.translate('Hello ${name}, see you in ${scope::number} days')).to eql('Hello James, see you in 10 days')
				end
			end

			context 'a string without connect interpolation' do
				it 'returns the string' do
					expect(interpolator.translate('Hello James, see you in 10 days')).to eql('Hello James, see you in 10 days')
				end
			end
		end

		context 'a variable with a selector' do

			context 'a string with valid connect interpolation' do
				it 'returns an interpolated string' do
					expect(interpolator.translate('Hello ${struct.first_part[2][6,4]}, see you in ${scope::number} days')).to eql('Hello John, see you in 10 days')
				end
			end
		end
	end


	context 'a string with invalid connect interpolation' do
		it 'returns an interpolated string' do
			expect(interpolator.translate('Hello ${name, see you in ${scope::number   } days')).to eql('Hello ${name, see you in 10 days')
		end
	end

	#
	# TODO: We need more puppet integrated tests with Puppet interpolation
	context 'a string with valid puppet interpolation' do
		it 'returns an interpolated string' do
			expect(interpolator.translate('We run on %{hostname}')).to match(/We run on/)
		end
	end

end