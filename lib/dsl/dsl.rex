class Dsl

macro
  WHITESPACE          \s
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9]*
  FULL_IDENTIFIER     {IDENTIFIER}(?:::{IDENTIFIER})?
  CONNECTION          \-\>
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  EXPONENT            [eE][+-]?{DIGIT}+
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  INCLUDE             include
  COMMENT             \#.*\n
  STRING              \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'

rule
  {COMMENT} 
  {WHITESPACE}
  {COMMA}             { [:COMMA, text] }
  {INCLUDE}           { [:INCLUDE, text] }
  {FULL_IDENTIFIER}   { [:FULL_IDENTIFIER, text] }
  {CONNECTION}        { [:CONNECTION, text] }
  {FLOAT}             { [:NUMBER, text.to_f] }
  {INT}               { [:NUMBER, text.to_i] }
  {STRING}            { [:STRING, dequote(text)]}
  .                   { [text, text] }

inner
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
