require 'spec_helper'
require 'hiera/backend/connect_backend'

RSpec.describe Hiera::Backend::Connect_backend do

  before do
    Hiera::Config.load({})
    allow(Hiera).to receive(:debug)
    allow(Hiera).to receive(:warn)
    allow(Hiera).to receive(:warn)
  end

  let(:subject) {described_class.new}

  context 'no connect section in hiera' do

    it 'raises an error' do
      expect {
          subject
        }.to raise_error(RuntimeError, 'Connect section not filled in hiera.yaml')
    end
  end

  context 'a valid section in hiera.yaml' do

    before do
      Hiera::Config.load({:connect => {}})
    end

    describe '#lookup' do
      it 'calls the DSL lookup_value' do
        expect_any_instance_of(Connect::Dsl).to receive(:lookup_value).with('a::b')
        subject.lookup('a::b', {}, nil, 0)
      end
    end

    context 'multiple #lookups' do

      describe 'with same hierarchy' do

        it 'uses parsed data' do
          Hiera::Config.load({:connect => {}, :hierarchy => ['common1']})
          expect(subject).to receive(:parse_config).once
          subject.lookup('a::b', {}, nil, 0)
          subject.lookup('a::c', {}, nil, 0)
        end

      end


      describe 'with differents hierarchy' do

        it 'reparses the data' do
          expect(subject).to receive(:parse_config).twice
          Hiera::Config.load({:connect => {}, :hierarchy => ['common1']})
          subject.lookup('a::b', {}, nil, 0)
          Hiera::Config.load({:connect => {}, :hierarchy => ['common2']})
          subject.lookup('a::c', {}, nil, 0)
        end

      end

    end

    describe '#lookup_values' do
      it 'calls the DSL lookup_values' do
        expect_any_instance_of(Connect::Dsl).to receive(:lookup_values).with('a::b')
        subject.lookup_values('a::b', {}, nil, 0)
      end
    end


    describe '#lookup_objects' do
      it 'calls the DSL lookup_objects' do
        expect_any_instance_of(Connect::Dsl).to receive(:lookup_objects).with('www.nu.nl', 'host')
        subject.lookup_objects('www.nu.nl', 'host', {}, nil, 0)
      end
    end



  end


end
