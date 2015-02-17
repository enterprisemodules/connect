class Dsl

macro
  WHITESPACE          \s
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9]*
  FULL_IDENTIFIER     {IDENTIFIER}(?:::{IDENTIFIER})?
  ASSIGNMENT          \=
  CONNECTION          \-\>
  STRING              '.*'|".*" 
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  EXPONENT            [eE][+-]?{DIGIT}+
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  INCLUDE             include
  COMMENT             \#.*

rule
  {COMMENT} 
  {WHITESPACE}
  {INCLUDE}           { [:INCLUDE, text] }
  {FULL_IDENTIFIER}   { [:FULL_IDENTIFIER, text] }
  {ASSIGNMENT}        { [:ASSIGNMENT, text] }
  {CONNECTION}        { [:CONNECTION, text] }
  {FLOAT}             { [:NUMBER, text.to_f] }
  {INT}               { [:NUMBER, text.to_i] }
  {STRING}            { [:STRING, dequote(text)]}

inner
  def dequote(line)
    line.chop![0] = ''
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
