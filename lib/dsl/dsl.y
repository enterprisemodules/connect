class Dsl
rule

	dsl
    : config
    | dsl config
  ;
  
  number
    : INTEGER
    | FLOAT
  ;

  config
    : assignment
    | connection
    | include_file
    | definition
  ;

  scope
    :
    | SCOPE
    ;

  selector
    :
    | SELECTOR
    ;

  literal
    : scope IDENTIFIER                         { result = "#{val[0]}#{val[1]}"}
  ;

  scalar
    : STRING
    | number
    | BOOLEAN
    | UNDEF
  ;

  value
    : scalar
    | array
    | hash
    | definition
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
    : literal '=' value                             { assign(val[0], val[2])}
  ;

	connection
    : literal '=' literal selector                  { connect(val[0], val[2], val[3])}
  ;

	include_file
    : INCLUDE STRING 													      { include_file(val[1])}
  ;

  definition
    : literal '(' STRING ')' selector iterator block 
                                                    { result = define(val[0], val[2], val[6], val[5], val[4])}
  ;

  block
    : 
    | '{' hashpairs '}'                             { result = val[1]}
    | DO hashpairs END                              { result = val[1]}
  ;

  iterator
    :
    | FROM INTEGER TO INTEGER                       { result = {:from => val[1], :to => val[3]}}
  ;

end

---- header
  require_relative 'dsl'
  require_relative 'lexer'

---- inner

def parse(input)
  scan_str(input)
end
