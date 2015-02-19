class Dsl
rule

	dsl
    : config
    | dsl config
  ;
  
  config
    : assignment
    | connection
    | include_stmnt
  ;

  literal
    : IDENTIFIER
    | SCOPE IDENTIFIER                            {result = "#{val[0]}#{val[1]}" }
  ;

  scalar
    : STRING
    | NUMBER
    | BOOLEAN
    | UNDEF
  ;

  value
    : scalar
    | array
    | hash
  ;

  array
    : '[' values ']'                                { result = val[1]}
    | '[' ']'                                       { result = []}
  ;

  hash
    : '{' hashpairs '}'                             { result = val[1]}
    | '{' '}'                                       { result = {}} 
  ;

  hashpairs
    : hashpair                                      
    | hashpairs ',' hashpair                        { result.merge!(val[2])}
  ;

  hashkey
    : IDENTIFIER                                    { result = val[0].to_sym}
    | scalar
  ;

  hashpair
    : hashkey ':' value                             { result = {val[0] => val[2]} }
    | hashkey HASH_ROCKET value                     { result = {val[0] => val[2]} }
  ;

  values
    : values ',' value                              { result = val[0] << val[2]}
    | value                                         { result = [val[0]]}
  ;

	assignment
    : literal '=' value                             { set(val[0], val[2])}
  ;

	connection
    : literal '=' literal                           { connect(val[0], val[2])}
  ;

	include_stmnt
    : INCLUDE STRING 													      { parse_file(val[1])}
  ;

end

---- header
  require_relative 'dsl'
  require_relative 'lexer'
  require 'byebug'

  DEFAULT_PATH = "/etc/puppet/config/"

---- inner

