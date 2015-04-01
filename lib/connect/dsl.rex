module Connect

class Dsl

macro
  NEWLINE              \n
  IDENTIFIER          [a-zA-Z][a-zA-Z0-9_]*
  SCOPE               (?:(?:{IDENTIFIER})?::)+
  WHITESPACE          [\s|\t]+
  DIGIT               [0-9]
  INT                 {DIGIT}+
  FLOAT               {DIGIT}+\.{DIGIT}+
  COMMENT             \#.*$
  DOUBLE_QUOTED       \"(\\.|[^\\"])*\"
  SINGLE_QUOTED       \'(\\.|[^\\'])*\'
  TRUE                TRUE|true
  FALSE               FALSE|false
  UNDEF               undefined|undef|nil
  HASH_ROCKET         \=\>
  DOUBLE_COLON        ::
  DO                  do\s
  IMPORT              import\s
  END                 end\s
  FROM                from\s
  TO                  to\s
  WITH                with\s
  INTO                into\s
  INCLUDE             include\s
  AND                 and\s|\&\&
  OR                  or\s|(\|\|)

rule
  {NEWLINE}
  {COMMENT} 
  {OR}                    { [:OR, text]}
  {AND}                   { [:AND, text]}
  {DO}                    { [:DO, text]}
  {END}                   { [:END, text]}
  {FROM}                  { [:FROM, text]}
  {TO}                    { [:TO, text]}
  {IMPORT}                { [:IMPORT, text]}
  {INTO}                  { [:INTO, text]}
  {WITH}                  { [:WITH, text]}
  {INCLUDE}               { [:INCLUDE, text] }
  {TRUE}                  { [:BOOLEAN, true]}
  {FALSE}                 { [:BOOLEAN, false]}
  {UNDEF}                 { [:UNDEF, nil]}
  {SCOPE}                 { [:SCOPE, text]}
  {IDENTIFIER}            { [:IDENTIFIER, text] }
  \=\>                    { [:HASH_ROCKET, text]}
  {FLOAT}                 { [:FLOAT, text.to_f] }
  {INT}                   { [:INTEGER, text.to_i] }
  {DOUBLE_QUOTED}        { [:DOUBLE_QUOTED, dequote(text)]}
  {SINGLE_QUOTED}        { [:SINGLE_QUOTED, dequote(text)]}
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
end