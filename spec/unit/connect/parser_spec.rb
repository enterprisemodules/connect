require 'spec_helper'
require 'connect/dsl'

RSpec.describe 'Parser' do

  let(:dsl) { Connect::Dsl.new }


  describe 'empty file' do

    it 'is parsed' do
      expect {
        dsl.parse(<<-EOD)
                     

        EOD
        }.not_to raise_error
    end

  end


  describe 'Hash syntax' do

    context 'without trailing comma' do
      it 'is parsed' do
        expect(dsl).to receive(:assign).with('a', {:a=>1,:b=>2}, nil)
        dsl.parse(<<-EOD)
        a = {a:1,b:2}
        EOD
      end
    end

    context 'with trailing comma' do
      it 'is parsed' do
        expect(dsl).to receive(:assign).with('a', {:a=>1,:b=>2}, nil)
        dsl.parse(<<-EOD)
        a = {a:1,b:2,}
        EOD
      end
    end
  end

  describe 'Array syntax' do

    context 'without trailing comma' do
      it 'is parsed' do
        expect(dsl).to receive(:assign).with('a', [1,2,3,4], nil)
        dsl.parse(<<-EOD)
        a = [1,2,3,4]
        EOD
      end
    end

    context 'with trailing comma' do
      it 'is parsed' do
        expect(dsl).to receive(:assign).with('a', [1,2,3,4], nil)
        dsl.parse(<<-EOD)
        a = [1,2,3,4,]
        EOD
      end
    end
  end


  describe 'scalar assignments' do

    it 'boolean' do
      expect(dsl).to receive(:assign).with('a', true, nil)
      dsl.parse(<<-EOD)
      a = true
      EOD
    end

    it 'undef' do
      expect(dsl).to receive(:assign).with('a', nil, nil)
      dsl.parse(<<-EOD)
      a = undefined
      EOD
    end

    it 'integer' do
      expect(dsl).to receive(:assign).with('a', 1, nil)
      dsl.parse(<<-EOD)
      a = 1
      EOD
    end

    it 'float' do
      expect(dsl).to receive(:assign).with('a', 1.1, nil)
      dsl.parse(<<-EOD)
      a = 1.1
      EOD
    end

    it 'string' do
      expect(dsl).to receive(:assign).with('a', 'hello', nil)
      dsl.parse(<<-EOD)
      a = 'hello'
      EOD
    end
  end

  describe 'Array assignments' do

    it 'integers' do
      expect(dsl).to receive(:assign).with('a', [1,2,3], nil)
      dsl.parse(<<-EOD)
      a = [1,2,3]
      EOD
    end

    it 'with reference' do
      expect(dsl).to receive(:assign).with('a', [1,Connect::Entry::Connection,3], nil)
      dsl.parse(<<-EOD)
      a = [1,b,3]
      EOD
    end


    it 'empty array' do
      expect(dsl).to receive(:assign).with('a', [], nil)
      dsl.parse(<<-EOD)
      a = []
      EOD
    end

  end

  describe 'Hash assignments' do

    it 'using  hash rocket syntax' do
      expect(dsl).to receive(:assign).with('a', {:a=>10}, nil)
      dsl.parse(<<-EOD)
      a = { a=>10}
      EOD
    end


    it 'using colon syntax' do
      expect(dsl).to receive(:assign).with('a', {:a=>10}, nil)
      dsl.parse(<<-EOD)
      a = { a:10}
      EOD
    end

    it 'empty hash' do
      expect(dsl).to receive(:assign).with('a', {}, nil)
      dsl.parse(<<-EOD)
      a = {}
      EOD
    end

    it 'using a reference' do
      expect(dsl).to receive(:assign).with('a', {:a=>Connect::Entry::Connection}, nil)
      dsl.parse(<<-EOD)
      a = { a:b}
      EOD
    end

    it 'using a single object' do
      expect(dsl).to receive(:assign).with('a', Hash, nil)
      dsl.parse(<<-EOD)
      a = { x: 10,
            obj('test')
          }
      EOD
    end

    it 'using a multiple objects' do
      expect(dsl).to receive(:assign).with('a', Hash, nil)
      dsl.parse(<<-EOD)
      a = { 
            something('else'),
            x: 10,
            obj('test')
          }
      EOD
    end



  end

  describe 'connections' do

    context 'no selector' do
      it 'connects two variables' do
        expect(dsl).to receive(:connect).with('a', 'b', nil)
        dsl.parse(<<-EOD)
        a = b
        EOD
      end
    end

    context 'with a selector' do
      it 'connects two variables' do
        expect(dsl).to receive(:connect).with('a', 'b', '[0].ip')
        dsl.parse(<<-EOD)
        a = b[0].ip
        EOD
      end
    end


  end

  describe 'include' do

    context 'without a specfied scope' do

      it 'includes a config' do
        expect(dsl).to receive(:include_file).with('a.a')
        dsl.parse(<<-EOD)
        include 'a.a'
        EOD
      end

    end

    context 'with a specfied scope' do

      it 'includes a config in a pecified scope' do
        expect(dsl).to receive(:include_file).with('a.a', 'test::')
        dsl.parse(<<-EOD)
        include 'a.a' into test::
        EOD
      end

    end


  end

  describe 'import' do

    context 'a scope specified' do
      it 'pushes and pos the scope' do
        allow(dsl).to receive(:datasource)
        allow(dsl).to receive(:import)
        expect(dsl).to receive(:push_scope).with('scope::').ordered
        expect(dsl).to receive(:pop_scope).ordered
        dsl.parse(<<-EOD)
        import from puppetdb into scope:: {
          a = 'hallo'
        }
        EOD
      end
    end

    context 'without a scope' do
      it 'doesn\'t manage the scope' do
        allow(dsl).to receive(:datasource) 
        allow(dsl).to receive(:import) 
        expect(dsl).not_to receive(:push_scope).with('scope::')
        expect(dsl).not_to receive(:pop_scope)
        dsl.parse(<<-EOD)
        import from puppetdb { 
          a = 'hallo'
        }
        EOD
      end
    end

    context 'datasource without parameters' do
      it 'call\'s the datasource initialize without parameters'  do
        allow(dsl).to receive(:import) 
        expect(dsl).to receive(:datasource).with('puppetdb', [])
        dsl.parse(<<-EOD)
        import from puppetdb { 
          a = 'hallo'
        }
        EOD
      end
    end

    context 'datasource with parameters' do
      it 'call\'s the datasource initialize with parameters'  do
        allow(dsl).to receive(:import) 
        expect(dsl).to receive(:datasource).with('puppetdb', [10,'hello'])
        dsl.parse(<<-EOD)
        import from puppetdb(10,'hello') { 
          a = 'hallo'
        }
        EOD
      end
    end

    context 'single import statement' do
      it 'call\'s the datasource initialize with parameters'  do
        allow(dsl).to receive(:datasource) 
        expect(dsl).to receive(:import).with('a', 'hallo')
        dsl.parse(<<-EOD)
        import from puppetdb(10,'hello') {
          a = 'hallo'
        }
        EOD
      end
    end

    context 'multiple import statement' do
      it 'call\'s the datasource initialize with parameters'  do
        allow(dsl).to receive(:datasource) 
        allow(dsl).to receive(:import) 
        expect(dsl).to receive(:import).with('a', 'hallo').ordered
        expect(dsl).to receive(:import).with('b', 'anything').ordered
        dsl.parse(<<-EOD)
        import from puppetdb(10,'hello') {
          a = 'hallo'
          b = 'anything'
        }
        EOD
      end
    end


  end

  describe 'with' do

    context 'a single default scope' do
      context 'using begin and end' do
        it 'set\'s the default scope' do
          expect(dsl).to receive(:push_scope).with('my_scope::')
          expect(dsl).to receive(:pop_scope)
          dsl.parse(<<-EOD)
          with my_scope:: do
            a = 10
          end
          EOD
        end
      end

      context 'using \{ and \}' do
        it 'set\'s the default scope' do
          expect(dsl).to receive(:push_scope).with('my_scope::')
          expect(dsl).to receive(:pop_scope)
          dsl.parse(<<-EOD)
          with my_scope:: {
            a = 10
          }
          EOD
        end
      end
    end


    context 'stacked default scopes' do
      context 'using begin and end' do
        it 'includes set\'s the default scope' do
          expect(dsl).to receive(:push_scope).with('my_first_scope::')
          expect(dsl).to receive(:push_scope).with('my_second_scope::')
          expect(dsl).to receive(:pop_scope).twice
          dsl.parse(<<-EOD)
          with my_first_scope:: do
            with my_second_scope:: do
              a = 10
            end
          end
          EOD
        end
      end

      context 'using \{ and \}' do
        it 'includes set\'s the default scope' do
          expect(dsl).to receive(:push_scope).with('my_first_scope::')
          expect(dsl).to receive(:push_scope).with('my_second_scope::')
          expect(dsl).to receive(:pop_scope).twice
          dsl.parse(<<-EOD)
          with my_first_scope:: {
            with my_second_scope:: {
              a = 10
            }
          }
          EOD
        end
      end
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

  context 'using unquoted strings' do
    it 'defines an object' do
      expect(dsl).to receive(:define).with('host','dns', { :ip => '10.0.0.1', :fqdn => 'dns.a.b'}, nil)
      dsl.parse(<<-EOD)
      host(dns) do ip: '10.0.0.1', fqdn: 'dns.a.b'end
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

  describe 'interpolation' do
    context 'double quoted strings' do

      it 'are passed to the interpolation filter' do
        expect(dsl).to receive(:interpolate).with("hallo ${foo::bar} and ${hallo}")
        dsl.parse(<<-EOD)
        a = "hallo ${foo::bar} and ${hallo}"
        EOD
      end
    end

    context 'single quoted strings' do

      it 'are passed without interpolation' do
        expect(dsl).not_to receive(:interpolate).with("hallo ${foo::bar} and ${hallo}")
        dsl.parse(<<-EOD)
        a = 'hallo ${foo::bar} and ${hallo}'
        EOD
      end
    end

  end

  describe 'simple calculations' do

    describe 'power' do

      it 'powers two arguments' do
        expect(dsl).to receive(:power).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 ^ 2
        EOD
      end
    end

    describe 'multiplying' do

      it 'multiplies two arguments' do
        expect(dsl).to receive(:multiply).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 * 2
        EOD
      end
    end

    describe 'adding' do

      it 'adds two arguments' do
        expect(dsl).to receive(:add).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 + 2
        EOD
      end
    end

    describe 'subtracting' do

      it 'subtracts two arguments' do
        expect(dsl).to receive(:subtract).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 - 2
        EOD
      end
    end

    describe 'or-ing' do

      it 'or \'s two arguments' do
        expect(dsl).to receive(:do_or).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 or 2
        EOD
      end
    end

   describe 'and-ing' do

      it 'and \'s two arguments' do
        expect(dsl).to receive(:do_and).with(1,2)
        dsl.parse(<<-EOD)
        a = 1 && 2
        EOD
      end
    end

  end


  describe 'error handling' do

    let(:error_config)     { Pathname.new('./examples/error.config').expand_path.to_s}

    it ' reports errors with line numbers' do
      expect{
        dsl.include_file(error_config)
      }.to raise_error(ParseError, /Syntax error on line 4/)
    end


    it ' reports errors with file names' do
      expect{
        dsl.include_file(error_config)
      }.to raise_error(ParseError, /config file '#{error_config}'/)
    end

  end



end
