require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'selectors' do

  let(:dsl) { Connect::Dsl.new}

  context "using method selectors" do

    context'invalid selector' do
      context 'on a Hash' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a.invalidselector
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

      context 'on a String' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = 'astring'
            b = a.invalidselector
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

      context 'on an Integer' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = 10
            b = a.invalidselector
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

    end

    context 'single valid' do

      context'selector on a Hash' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a.foo
          EOD
          expect(dsl.lookup_value('b')).to eql('bar')
        end
      end

      context'selector on a Object' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = foo('bar') {'foo': 'bar'}
            b = a.foo
          EOD
          expect(dsl.lookup_value('b')).to eql('bar')
        end
      end

      context'selector on an Array' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = [1,2,3,4]
            b = a.first
          EOD
          expect(dsl.lookup_value('b')).to eq 1
        end
      end

      context'selector on an String' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = 'hallo'
            b = a.chop
          EOD
          expect(dsl.lookup_value('b')).to eq 'hall'
        end
      end

    end


    context 'multiple valid' do

      context'selector on a Hash' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a.foo.chop
          EOD
          expect(dsl.lookup_value('b')).to eql('ba')
        end
      end

      context'selector on a Object' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = foo('bar') {'foo': 'bar'}
            b = a.foo.chop
          EOD
          expect(dsl.lookup_value('b')).to eql('ba')
        end
      end

      context'selector on an Array' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = [1,2,3,4]
            b = a.first.next
          EOD
          expect(dsl.lookup_value('b')).to eq 2
        end
      end

      context'selector on an String' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = 'hallo'
            b = a.chop.upcase
          EOD
          expect(dsl.lookup_value('b')).to eq 'HALL'
        end
      end

    end


  end


  context "using Array selectors" do

    context'invalid selector' do
      context 'on a Hash' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a['invalid']
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

      context 'on a String' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = 'astring'
            b = a[10,'invalidselector']
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

      context 'on an Integer' do
        it 'raises an error' do
          dsl.parse(<<-EOD)
            a = 10
            b = a['invalid']
          EOD
          expect {
            dsl.lookup_value("b")
          }.to raise_error(/usage of invalid selector/)
        end
      end

    end

    context 'single valid' do

      context'selector on a Hash' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a['foo']
          EOD
          expect(dsl.lookup_value('b')).to eql('bar')
        end
      end

      context'selector on a Object' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = foo('bar') {'foo': 'bar'}
            b = a['foo']
          EOD
          expect(dsl.lookup_value('b')).to eql('bar')
        end
      end

      context'selector on an Array' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = [1,2,3,4]
            b = a[0,2]
          EOD
          expect(dsl.lookup_value('b')).to eq [1,2]
        end
      end

      context'selector on an String' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = 'hallo'
            b = a[0,1]
          EOD
          expect(dsl.lookup_value('b')).to eq 'h'
        end
      end

    end


    context 'multiple valid' do

      context'selector on a Hash' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = {'foo': 'bar'}
            b = a['foo'][0,2]
          EOD
          expect(dsl.lookup_value('b')).to eql('ba')
        end
      end

      context'selector on a Object' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = foo('bar') {'foo': 'bar'}
            b = a['foo'][0,2]
          EOD
          expect(dsl.lookup_value('b')).to eql('ba')
        end
      end

      context'selector on an Array' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = [1,2,3,4]
            b = a[0,2][1]
          EOD
          expect(dsl.lookup_value('b')).to eq 2
        end
      end

      context'selector on an String' do
        it 'is retrievable' do
          dsl.parse(<<-EOD)
            a = 'hallo'
            b = a[1,3][0,2]
          EOD
          expect(dsl.lookup_value('b')).to eq 'al'
        end
      end

    end

  end

  context 'special selectors' do

    context 'Array extraction' do

      context'on an array of hashes' do
        it 'returns an array of entries' do
          dsl.parse(<<-EOD)
            a = [
              {name: 'foo'},
              {name: 'bar'}
            ]
            b = a.extract('name')
          EOD
          expect(dsl.lookup_value('b')).to eq ['foo','bar']
        end
      end

      context'on an array of objects' do
        it 'returns an array of entries' do
          dsl.parse(<<-EOD)
            a = [
              foo('jabadoo_1'){name: 'foo'},
              foo('jabadoo_2'){name: 'bar'}
            ]
            b = a.extract('name')
          EOD
          expect(dsl.lookup_value('b')).to eq ['foo','bar']
        end
      end

      context'on an array of integers' do
        it 'fails' do
          dsl.parse(<<-EOD)
            a = [1,2,3,4,5,6]
            b = a.extract('name')
          EOD
          expect{
            dsl.lookup_value('b')
          }.to raise_error(/usage of invalid selector/)
        end
      end

    end

    context 'Resource entries' do

      context'on an objects' do
        it 'returns a valid hash for the object' do
          dsl.parse(<<-EOD)
            a = something('/file') {ensure: 'present', invalid_attr: 'true', checksum: 10}
            b = a.to_resource('file')
          EOD
          expect(dsl.lookup_value('b')).to eq({'/file' => {'ensure' => 'present', 'checksum' => 10}})
        end
      end
    end

    context 'Slice entries' do

      context'on an object' do
        it 'returns hash with only selected items' do
          dsl.parse(<<-EOD)
            a = something('file') {ensure: 'present', invalid_attr: 'true', checksum: 10}
            b = a.slice('ensure', 'checksum')
          EOD
          expect(dsl.lookup_value('b')).to eq({'file' => {'ensure' => 'present', 'checksum' => 10}})
        end
      end

      context'on a hash' do
        it 'returns the hash with only selected items' do
          dsl.parse(<<-EOD)
            a = {ensure: 'present', invalid_attr: 'true', checksum: 10}
            b = a.slice('ensure', 'checksum')
          EOD
          expect(dsl.lookup_value('b')).to eq({'ensure' => 'present', 'checksum' => 10})
        end
      end
    end
  end


end

