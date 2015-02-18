class Dsl
rule
	dsl: config | dsl config;
  config: assignment | connection | include_stmnt ;

  scalar: STRING | NUMBER;

  value: scalar | array;

  array: '[' values ']'              { result = val[1]}
  ;

  values: 
    values ',' value                 { result = val[0] << val[2]}
  |  value                           { result = [val[0]]}
  ;

	assignment:
    FULL_IDENTIFIER '=' value   				    { set(val[0], val[2])}
  ;
	connection: 
    FULL_IDENTIFIER CONNECTION FULL_IDENTIFIER    { connect(val[0], val[2])}
  ;

	include_stmnt: 
    INCLUDE STRING 													{ puts 'include'}
  ;
end

---- header
  require_relative 'dsl'
  require_relative 'lexer'

---- inner

  def parse(input)
    scan_str(input)
  end