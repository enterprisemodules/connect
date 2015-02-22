class Dsl

macro
  SCOPED              
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9]*
  SCOPED              (?:{IDENTIFIER}::)+{IDENTIFIER}
  SELECTOR            (?:\[\d+\]|\.{IDENTIFIER})*
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  COMMENT             \#.*\n
  STRING              \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'
  TRUE                TRUE|true
  FALSE               FALSE|false
  UNDEF               undefined|undef|nil
  HASH_ROCKET         \=\>
  DOUBLE_COLON        ::

rule
  {COMMENT} 
  do                      { [:DO, text]}
  end                     { [:END, text]}
  from                    { [:FROM, text]}
  to                      { [:TO, text]}
  include                 { [:INCLUDE, text] }
  {TRUE}                  { [:BOOLEAN, true]}
  {FALSE}                 { [:BOOLEAN, false]}
  {UNDEF}                 { [:UNDEF, nil]}
  {SCOPED}{SELECTOR}      { [:SCOPED, text]}
  {IDENTIFIER}{SELECTOR}  { [:IDENTIFIER, text] }
  \=\>                    { [:HASH_ROCKET, text]}
  {FLOAT}                 { [:FLOAT, text.to_f] }
  {INT}                   { [:INTEGER, text.to_i] }
  {STRING}                { [:STRING, dequote(text)]}
  {WHITESPACE}
  .                       { [text, text] }

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
