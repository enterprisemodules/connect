# encoding: UTF-8
require 'spec_helper'
require 'puppet/face'
require 'hiera/backend/connect_backend'

RSpec.describe "puppet connect values" do

  before do
    Hiera::Config.load({:connect => {}})
    allow(Hiera).to receive(:debug)
    allow(Hiera).to receive(:warn)
    allow(Hiera).to receive(:warn)
  end

  describe "inline documentation" do

    subject { Puppet::Face[:connect, :current].get_action :values }

    its(:summary)     { is_expected.to match(/List the value\(s\) specfied in the connect config file\(s\)/) }
    its(:description) { is_expected.to match(/Connect wil show you the specfied name. You can use regular expresion wildcards for the name/) }
    its(:examples)    { is_expected.to match(/\$ puppet connect values a_value/)}
    its(:arguments)   { is_expected.to match(/variable_name/)}
  end

  describe "its action" do

    subject { Puppet::Face[:connect, :current] }

    before do       
      expect(Puppet).to receive(:[]).and_return(Pathname.new(File.dirname(__FILE__)).parent.parent.parent.parent.parent)
    end

    it 'calls the dsl lookup method' do
      expect_any_instance_of(Hiera::Backend::Connect_backend).to receive(:lookup_values).with('scope::a_value', {}, false, 1).and_return([])
      expect(Hiera).to receive(:new)
      allow(Puppet::Face.define(:connect, '0.0.1')).to receive(:scope).and_return({})
      subject.values('scope::a_value',{})
    end

  end

end
