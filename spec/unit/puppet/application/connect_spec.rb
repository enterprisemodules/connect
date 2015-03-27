require 'spec_helper'
require 'puppet/application/connect'

RSpec.describe Puppet::Application::Connect do
  it "should be a subclass of Puppet::Application::FaceBase" do
    expect(Puppet::Application::Connect.superclass).to equal(Puppet::Application::FaceBase)
  end
end
