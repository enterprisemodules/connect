class Dsl

macro
  WHITESPACE          \s
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9]*
  SCOPE               {IDENTIFIER}::
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  EXPONENT            [eE][+-]?{DIGIT}+
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  INCLUDE             include
  COMMENT             \#.*\n
  STRING              \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'
  TRUE                TRUE|true
  FALSE               FALSE|false
  UNDEF               undef|undefined|nil
  HASH_ROCKET         \=\>
  DOUBLE_COLON        ::


rule
  {COMMENT} 
  {INCLUDE}           { [:INCLUDE, text] }
  {DOUBLE_COLON}      { [:DOUBLE_COLON, text]}
  {SCOPE}             { [:SCOPE, text]} 
  {IDENTIFIER}        { [:IDENTIFIER, text] }
  {HASH_ROCKET}       { [:HASH_ROCKET, text]}
  {TRUE}              { [:BOOLEAN, true]}
  {FALSE}             { [:BOOLEAN, false]}
  {UNDEF}             { [:UNDEF, nil]}
  {COMMA}             { [:COMMA, text] }
  {FLOAT}             { [:NUMBER, text.to_f] }
  {INT}               { [:NUMBER, text.to_i] }
  {STRING}            { [:STRING, dequote(text)]}
  {WHITESPACE}
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
