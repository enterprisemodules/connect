class Dsl
rule
	dsl: config | dsl config;
	config: assignment | connection | include_stmnt ;
	assignment:
    FULL_IDENTIFIER ASSIGNMENT STRING   				 { puts 'string assignment'}
  | FULL_IDENTIFIER ASSIGNMENT NUMBER   				 { puts 'number assignment'}
  ;
	connection: 
    FULL_IDENTIFIER CONNECTION FULL_IDENTIFIER   { puts 'connection'}
  ;
	include_stmnt: 
    INCLUDE STRING 														   { puts 'include'}
  ;
end

---- header
  require_relative 'dsl'
  require_relative 'lexer'

---- inner
  def parse(input)
    scan_str(input)
  end