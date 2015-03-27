# encoding: UTF-8
require 'spec_helper'
require 'puppet/face'
require 'hiera/backend/connect_backend'

RSpec.describe "puppet connect objects" do

  subject { Puppet::Face[:connect, :current] }

  let(:options) {{}}

  before do
    Hiera::Config.load({:connect => {}})
    allow(Hiera).to receive(:debug)
    allow(Hiera).to receive(:warn)
    allow(Hiera).to receive(:warn)
  end

  describe "inline documentation" do

    subject { Puppet::Face[:connect, :current].get_action :objects }

    its(:summary)     { is_expected.to match(/List the objects specfied in the connect config/) }
    its(:description) { is_expected.to match(/List the object\(s\) specfied in the connect config file\(s\). If you specfy a parameter name/) }
    its(:examples)    { is_expected.to match(/\$ puppet connect objects www.apache.org --type host/)}
    its(:arguments)   { is_expected.to match(/object_name/)}
  end

  describe 'the options' do
    it "should accept the --type option" do
      options[:type] = 'host'
      expect { subject.objects('', options)}.to_not raise_error
    end
  end

  describe "its action" do

    it 'call \'s the dsl lookup method' do
      expect_any_instance_of(Hiera::Backend::Connect_backend).to receive(:lookup_objects).with('www.demo.org', 'host', {}, false, 1)
      subject.objects('www.demo.org',{:type => 'host'})
    end

  end

end
