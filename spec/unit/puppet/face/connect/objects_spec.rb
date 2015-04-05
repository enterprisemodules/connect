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

    before do       
      expect(Puppet).to receive(:[]).and_return(Pathname.new(File.dirname(__FILE__)).parent.parent.parent.parent.parent)
    end

    it "should accept the --type option" do
      allow_any_instance_of(Hiera::Backend::Connect_backend).to receive(:lookup_objects).with('host', 'www.hajee.org', {}, false, 1).and_return([])
      allow(Hiera).to receive(:new)
      allow(Puppet::Face.define(:connect, '0.0.1')).to receive(:scope).and_return({})
      options[:type] = 'host'
      expect { subject.objects('www.hajee.org', options)}.to_not raise_error
    end
  end

  describe "its action" do

    subject { Puppet::Face[:connect, :current] }

    it 'calls the dsl lookup method' do
      expect_any_instance_of(Hiera::Backend::Connect_backend).to receive(:lookup_objects).with('host', 'www.hajee.org', {}, false, 1).and_return([])
      allow(Hiera).to receive(:new)
      allow(Puppet::Face.define(:connect, '0.0.1')).to receive(:scope).and_return({})
      subject.objects('www.hajee.org',{:type => 'host'})
    end

  end

end
