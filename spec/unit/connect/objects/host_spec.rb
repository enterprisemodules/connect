require 'spec_helper'
require 'connect/objects/host'

RSpec.describe Connect::Objects::Host do

  context 'with a valid host name' do
    let(:host) {described_class.new('host', 'h.domain.nl',{:ip => '1.1.1.1'})}

    it 'extracts the hostname' do
      expect(host.hostname).to eq 'h'
    end

    it 'extracts the domain' do
      expect(host.domain).to eq 'domain.nl'
    end

    it 'returns the fqdn' do
      expect(host.fqdn).to eq 'h.domain.nl'
    end

  end

  context 'invalid host defintion' do

    it 'raises an error' do
      expect {
        described_class.new('host', 'invalid_name', {})
      }.to raise_error('Invalid host object definition')
    end
  end


end
