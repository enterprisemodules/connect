require 'spec_helper'
require 'connect/datasources/encrypted'

RSpec.describe Connect::Datasources::Encrypted do

  let(:password)          {'mydirtylittlesecret'}
  let(:string)            {'password_1'}
  let(:encrypted_string)  {'4tXI3V4yU3+E0b8MB4Td2A==|RGh76OTpA0wQ9pK1bCuCkA=='}
  let(:without_iv)        {'RGh76OTpA0wQ9pK1bCuCkA=='}
  let(:without_value)     {'4tXI3V4yU3+E0b8MB4Td2A==|'}
  let(:invalid_iv)        {'6tYI3V4yU3+E9b8MB4Td2A==|RGh76OTpA0wQ9pK1bCuCkA=='}
  let(:invalid_value)     {'4tXI3V4yU3+E0b8MB4Td2A==|RGh76OPpA0wQ9pK1bCuCkA=='}

  Encrypted = described_class

  let(:datasource)        { Encrypted.new( 'encrypted', password)}

  describe '#initialize' do
    context 'without a password' do
      it 'raises an argument error' do
        expect {
          Encrypted.new('encrypted')
        }.to raise_error(ArgumentError,'password required as first argument of encrypted datasource')
      end
    end

    context 'with a password' do
      it 'passes normaly' do
        expect {
          Encrypted.new('encrypted', password)
        }.not_to raise_error
      end
    end
  end


  describe "#lookup" do

    context 'without a valid iv' do

      it 'raises an argument error' do
        expect {
          datasource.lookup(without_iv)
        }.to raise_error(ArgumentError,'invalid value for decryption')
      end
    end


    context 'with an invalid value' do

      it 'raises an argument error' do
        expect {
          datasource.lookup(invalid_value)
        }.to raise_error(OpenSSL::Cipher::CipherError)
      end
    end

    context 'with an invalid iv' do

      it 'returns the value' do
        expect(datasource.lookup(invalid_iv)).not_to eq string
      end

    end


    context 'with a valid value' do

      it 'returns the value' do
        expect(datasource.lookup(encrypted_string)).to eq string
      end

    end

  end

end

