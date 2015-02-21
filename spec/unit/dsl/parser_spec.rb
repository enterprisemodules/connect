require 'spec_helper'
require 'dsl/dsl'

RSpec.describe 'Parser' do

  let(:dsl) { Dsl.new }

  describe 'scalar assignments' do

    it 'boolean' do
      expect(dsl).to receive(:assign).with('a', true)
      dsl.parse(<<-EOD)
      a = true
      EOD
    end

    it 'undef' do
      expect(dsl).to receive(:assign).with('a', nil)
      dsl.parse(<<-EOD)
      a = undefined
      EOD
    end

    it 'integer' do
      expect(dsl).to receive(:assign).with('a', 1)
      dsl.parse(<<-EOD)
      a = 1
      EOD
    end

    it 'float' do
      expect(dsl).to receive(:assign).with('a', 1.1)
      dsl.parse(<<-EOD)
      a = 1.1
      EOD
    end

    it 'string' do
      expect(dsl).to receive(:assign).with('a', 'hello')
      dsl.parse(<<-EOD)
      a = 'hello'
      EOD
    end
  end

  describe 'Array assignments' do

    it 'integers' do
      expect(dsl).to receive(:assign).with('a', [1,2,3])
      dsl.parse(<<-EOD)
      a = [1,2,3]
      EOD
    end

    it 'empty array' do
      expect(dsl).to receive(:assign).with('a', [])
      dsl.parse(<<-EOD)
      a = []
      EOD
    end

  end

  describe 'Hash assignments' do

    it 'using  hash rocket syntax' do
      expect(dsl).to receive(:assign).with('a', {:a=>10})
      dsl.parse(<<-EOD)
      a = { a=>10}
      EOD
    end


    it 'using colon syntax' do
      expect(dsl).to receive(:assign).with('a', {:a=>10})
      dsl.parse(<<-EOD)
      a = { a:10}
      EOD
    end

    it 'empty hash' do
      expect(dsl).to receive(:assign).with('a', {})
      dsl.parse(<<-EOD)
      a = {}
      EOD
    end
  end

  describe 'connections' do

    it 'connects two variables' do
      expect(dsl).to receive(:connect).with('a', 'b')
      dsl.parse(<<-EOD)
      a = b
      EOD
    end
  end

  describe 'include' do

    it 'includes a config' do
      expect(dsl).to receive(:include_file).with('a.a')
      dsl.parse(<<-EOD)
      include 'a.a'
      EOD
    end
  end

  describe 'object definitions' do

    context 'using curly braces' do
      it 'defines an object' do
        expect(dsl).to receive(:define).with('host','dns', { :ip => '10.0.0.1', :fqdn => 'dns.a.b'}, nil)
        dsl.parse(<<-EOD)
        host('dns') { ip: '10.0.0.1', fqdn: 'dns.a.b'}
        EOD
      end
    end
  end

  context 'using do end' do
    it 'defines an object' do
      expect(dsl).to receive(:define).with('host','dns', { :ip => '10.0.0.1', :fqdn => 'dns.a.b'}, nil)
      dsl.parse(<<-EOD)
      host('dns') do ip: '10.0.0.1', fqdn: 'dns.a.b'end
      EOD
    end
  end

  context 'using an iterator' do
    it 'defines an object with an iterator' do
      expect(dsl).to receive(:define).with('host','dns', { :ip => '10.0.0.1', :fqdn => 'dns.a.b'},  {:from => 10, :to => 20})
      dsl.parse(<<-EOD)
      host('dns') from 10 to 20 do 
      	ip:   '10.0.0.1', 
      	fqdn: 'dns.a.b'end
      EOD
    end
  end


end
