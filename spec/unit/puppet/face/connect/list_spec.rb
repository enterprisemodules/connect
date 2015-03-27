# encoding: UTF-8
require 'spec_helper'
require 'puppet/face'
require 'hiera/backend/connect_backend'

RSpec.describe "puppet attribute generator" do

  let(:backend) {Hiera::Backend::Connect_backend.new}

  before do
    allow(Hiera).to receive(:debug)
    allow(Hiera).to receive(:warn)
    allow(Hiera).to receive(:warn)
    allow(Hiera::Config).to receive(:[]).and_return({})
  end

  describe "inline documentation" do

    subject { Puppet::Face[:connect, :current].get_action :list }


    its(:summary)     { is_expected.to match(/List the value\(s\) specfied in the connect config file\(s\)/) }
    its(:description) { is_expected.to match(/Connect wil show you the specfied name. You can use regular expresion wildcards for the name/) }
    its(:examples)    { is_expected.to match(/\$ puppet connect list a_value/)}
    its(:arguments)   { is_expected.to match(/variable_name/)}
  end

  describe "its action" do

    subject { Puppet::Face[:connect, :current] }

    it 'call \'s the dsl lookup method' do
      expect_any_instance_of(Hiera::Backend::Connect_backend).to receive(:lookup_values).with('scope::a_value', {}, false, 1)
      subject.list('scope::a_value',{})
    end

  end

end
