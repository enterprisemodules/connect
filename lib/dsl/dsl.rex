class Dsl

macro
  NEWLINE              \n
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9_]*
  SCOPE               (?:{IDENTIFIER}::)+
  SELECTOR            (?:\[\d+\]|\.{IDENTIFIER})+
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  COMMENT             \#.*(?:\n|$)
  STRING              \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'
  TRUE                TRUE|true
  FALSE               FALSE|false
  UNDEF               undefined|undef|nil
  HASH_ROCKET         \=\>
  DOUBLE_COLON        ::
  DO                  do\s
  END                 end\s
  FROM                from\s
  TO                  to\s
  INCLUDE             include\s

rule
  {COMMENT} 
  {DO}                    { [:DO, text]}
  {END}                   { [:END, text]}
  {FROM}                  { [:FROM, text]}
  {TO}                    { [:TO, text]}
  {INCLUDE}               { [:INCLUDE, text] }
  {TRUE}                  { [:BOOLEAN, true]}
  {FALSE}                 { [:BOOLEAN, false]}
  {UNDEF}                 { [:UNDEF, nil]}
  {SCOPE}                 { [:SCOPE, text]}
  {IDENTIFIER}            { [:IDENTIFIER, text] }
  {SELECTOR}              { [:SELECTOR, text]}
  \=\>                    { [:HASH_ROCKET, text]}
  {FLOAT}                 { [:FLOAT, text.to_f] }
  {INT}                   { [:INTEGER, text.to_i] }
  {STRING}                { [:STRING, dequote(text)]}
  {WHITESPACE}
  {NEWLINE}
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
