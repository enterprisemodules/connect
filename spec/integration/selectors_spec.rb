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
            b = a[1,2][0]
          EOD
          expect(dsl.lookup_value('b')).to eq 'a'
        end
      end

    end


  end


end

