class Connect::Dsl

prechigh
  nonassoc SCOPE
  nonassoc IDENTIFIER
preclow

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
    | include
    | import
    | definition
    | with
  ;

  #
  # Basic building blocks
  #
  block_begin
    : DO
    | '{'
    ;

  block_end
    : END
    | '}'
    ;

  literal
    : SCOPE IDENTIFIER                         { result = "#{val[0]}#{val[1]}"}
    | IDENTIFIER                               { result = "#{val[0]}"}
  ;

  string
    : DOUBLE_QUOTED                            { result = interpolate(val[0])}
    | SINGLE_QUOTED
  ;

  scalar
    : string
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

  values
    : values ',' value                              { result = val[0] << val[2]}
    | values ',' reference                          { result = val[0] << val[2]}
    | value                                         { result = [val[0]]}
  ;

  parameters
    : parameters ',' parameter                      { result = val[0] << val[2]}
    | parameter                                     { result = [val[0]]}
  ;

  parameter
    : scalar
  ;

  reference
    : literal                                 {result = reference(val[0])}
    ;

  expression
    : value '^' value                         { result = power(val[0],val[2])} 
    | value '*' value                         { result = multiply(val[0],val[2])}
    | value '/' value                         { result = divide(val[0],val[2])}
    | value '+' value                         { result = add(val[0],val[2])}
    | value '-' value                         { result = subtract(val[0],val[2])}
    | value OR value                          { result = do_or(val[0],val[2])}
    | value AND value                         { result = do_and(val[0],val[2])}
    | value
  ;

  #
  # Selectors
  #
  selectors
    : selectors selector                      { result =val.join}
    | selector
    ;

  selector
    : array_selector
    | function_selector
    | special_selector
  ;

  array_selector
    : '[' parameters ']'                      { result = val[0] + to_param(val[1]) +  val[2]}
    ;

  function_selector
    : '.' IDENTIFIER                          { result = val.join}
    | '.' IDENTIFIER '(' parameters ')'       { result = val[0] + val[1] + val[2] + to_param(val[3]) +  val[4]}
    ;

  special_selector
    : '.' IDENTIFIER '(' '&' ':' IDENTIFIER')'    { result = val.join}
    ;

  #
  # with statement
  #
  with_scope_do
    : WITH SCOPE block_begin          { push_scope(val[1])}
    ;

  with
    : with_scope_do dsl block_end     { pop_scope }
  ;

  #
  # Define the Array syntax
  #
  array
    : '[' values optional_comma ']'                 { result = val[1]}
    | '[' reference ',' values optional_comma ']'   { result = val[3].unshift(val[1])}
    | '[' reference optional_comma ']'              { result = [val[1]] }
    | '[' ']'                                       { result = []}
  ;

  #
  # Define the Hash syntax
  #
  hash
    : '{' hashpairs optional_comma '}'              { result = val[1]}
    | '{' '}'                                       { result = MethodHash.new} 
  ;

  optional_comma:
    :
    | ','
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
    : hashkey ':' value                             { result = MethodHash[val[0], val[2]] }
    | hashkey HASH_ROCKET value                     { result = MethodHash[val[0], val[2]] }
    | hashkey ':' reference                         { result = MethodHash[val[0], val[2]] }
    | hashkey HASH_ROCKET reference                 { result = MethodHash[val[0], val[2]] }
    | definition                                    { result = MethodHash[val[0].object_id, val[0]]}
  ;

  #
  # Assignments and connections
  #
	assignment
    : literal '=' expression                        { assign(val[0], val[2], nil)}
    | literal '=' expression selectors              { assign(val[0], val[2], val[3])}
  ;

	connection
    : literal '=' literal                           { connect(val[0], val[2], nil)}
    | literal '=' literal selectors                 { connect(val[0], val[2], val[3])}
  ;

  #
  # Define the inport syntax
  #
	include
    : INCLUDE string 													      { include_file(val[1])}
    | INCLUDE string INTO SCOPE                     { include_file(val[1], val[3])}
  ;

  #
  # Define the import syntax
  #
  import
    : import_with_scope_begin import_with_scope_end 
    | IMPORT FROM datasource import_block
    ;

  import_with_scope_begin
    : IMPORT FROM datasource INTO SCOPE block_begin { push_scope(val[4])} 
    ;

  import_with_scope_end
    :  import_statements block_end                  { pop_scope} 
    ;

  import_block
    : block_begin import_statements block_end

  datasource
    : literal '(' parameters ')'                     { datasource( val[0], *val[2])} 
    | literal                                        { datasource( val[0], *[])}
    ;

  import_statements
    : import_statements import_statement
    | import_statement
    ;

  import_statement
    : literal '=' string                             { import(val[0], val[2])}
    ;

  #
  # Define object definitions syntax
  #
  definition
    : IDENTIFIER '(' string ')' iterator definition_block 
                                                    { result = define(val[0], val[2], val[5], val[4])}
    | IDENTIFIER '(' literal ')' iterator definition_block 
                                                    { result = define(val[0], val[2], val[5], val[4])}
  ;

  definition_block
    : 
    | block_begin hashpairs optional_comma block_end
                                                    { result = val[1]}
  ;

  iterator
    :
    | FROM INTEGER TO INTEGER                       { result = {:from => val[1], :to => val[3]}}
  ;

end

---- header
  require 'connect/dsl'
  require 'connect/lexer'

---- inner

  def parse(input)
    scan_str(input) unless empty_definition?(input)
  end

  def power(v1,v2)
    v1 ^ v2
  end

  def multiply(v1,v2)
    v1 * v2
  end

  def divide(v1,v2)
    v1 / v2
  end

  def add(v1,v2)
    v1 + v2
  end

  def subtract(v1,v2)
    v1 - v2
  end

  def do_or(v1,v2)
    v1 || v2
  end

  def do_and(v1,v2)
    v1 && v2
  end

  def on_error(token, value, vstack )
    position =  "Syntax error on line #{lineno} of config file '#{current_file}'"
    text = @ss.peek(20)
    unless value.nil?
      msg = "#{position} at value '#{value}' : #{text}"
    else
      msg = "#{position} at token '#{token}' : #{text}"
    end
    if @ss.eos?
      msg = "#{position}: Unexpected end of file"
    end
    raise ParseError, msg
  end

