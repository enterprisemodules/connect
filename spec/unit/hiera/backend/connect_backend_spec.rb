require 'spec_helper'
require 'hiera/backend/connect_backend'

RSpec.describe Hiera::Backend::Connect_backend do

  before do
    Hiera::Config.load({:connect => {}})
    allow(Hiera).to receive(:debug)
    allow(Hiera).to receive(:warn)
    allow(Hiera).to receive(:warn)
  end

  let(:subject) {described_class.new}

  describe '#lookup' do
    it 'calls the DSL lookup_value' do
      expect_any_instance_of(Connect::Dsl).to receive(:lookup_value).with('a::b')
      subject.lookup('a::b', {}, true, 0)
    end
  end

  describe '#lookup_values' do
    it 'calls the DSL lookup_values' do
      expect_any_instance_of(Connect::Dsl).to receive(:lookup_values).with('a::b')
      subject.lookup_values('a::b', {}, true, 0)
    end
  end


  describe '#lookup_objects' do
    it 'calls the DSL lookup_objects' do
      expect_any_instance_of(Connect::Dsl).to receive(:lookup_objects).with('www.nu.nl', 'host')
      subject.lookup_objects('www.nu.nl', 'host', {}, true, 0)
    end
  end


end
