#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lib/connect/dsl.rex".
#++

require 'racc/parser'
module Connect

class Dsl < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/\n/))
        ;

      when (text = @ss.scan(/\#.*\n/))
         action { @lineno += 1; nil}

      when (text = @ss.scan(/\#.*$/))
        ;

      when (text = @ss.scan(/iterate\s/))
         action { [:ITERATE, text]}

      when (text = @ss.scan(/step\s/))
         action { [:STEP, text]}

      when (text = @ss.scan(/or\s|(\|\|)/))
         action { [:OR, text]}

      when (text = @ss.scan(/and\s|\&\&/))
         action { [:AND, text]}

      when (text = @ss.scan(/do\s/))
         action { [:DO, text]}

      when (text = @ss.scan(/end\s/))
         action { [:END, text]}

      when (text = @ss.scan(/from\s/))
         action { [:FROM, text]}

      when (text = @ss.scan(/to\s/))
         action { [:TO, text]}

      when (text = @ss.scan(/import\s/))
         action { [:IMPORT, text]}

      when (text = @ss.scan(/into\s/))
         action { [:INTO, text]}

      when (text = @ss.scan(/with\s/))
         action { [:WITH, text]}

      when (text = @ss.scan(/include\s/))
         action { [:INCLUDE, text] }

      when (text = @ss.scan(/TRUE|true/))
         action { [:BOOLEAN, true]}

      when (text = @ss.scan(/FALSE|false/))
         action { [:BOOLEAN, false]}

      when (text = @ss.scan(/undefined|undef|nil/))
         action { [:UNDEF, nil]}

      when (text = @ss.scan(/(?:(?:[a-zA-Z][a-zA-Z0-9_]*)?::)+/))
         action { [:SCOPE, text]}

      when (text = @ss.scan(/[a-zA-Z][a-zA-Z0-9_]*/))
         action { [:IDENTIFIER, text] }

      when (text = @ss.scan(/\=\>/))
         action { [:HASH_ROCKET, text]}

      when (text = @ss.scan(/[0-9]+\.[0-9]+/))
         action { [:FLOAT, text.to_f] }

      when (text = @ss.scan(/[0-9]+/))
         action { [:INTEGER, text.to_i] }

      when (text = @ss.scan(/\"(\\.|[^\\"])*\"/))
         action { [:DOUBLE_QUOTED, dequote(text)]}

      when (text = @ss.scan(/\'(\\.|[^\\'])*\'/))
         action { [:SINGLE_QUOTED, dequote(text)]}

      when (text = @ss.scan(/\/.*\//))
         action { [:REGEXP, dequote(text)]}

      when (text = @ss.scan(/\.\./))
         action { [:DOUBLE_DOTS, text]}

      when (text = @ss.scan(/[\s|\t]+/))
        ;

      when (text = @ss.scan(/./))
         action { [text, text] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

    def dequote(line)
      line.chop![0] = ''
      line
    end
    def tokenize(code)
      scan_setup(code)
      tokens = []
      while token = next_token
        tokens << token
      end
      tokens
    end
  end
end # class
