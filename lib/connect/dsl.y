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
    | include_file
    | import_data
    | definition
    | default_scope
  ;

  selector
    :
    | SELECTOR
  ;

  block_begin
    : DO
    | '{'
    ;

  block_end
    : END
    | '}'
    ;


  with_scope_do
    : WITH SCOPE block_begin          { push_scope(val[1])}
    ;


  default_scope
    : with_scope_do dsl block_end     { pop_scope }
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

  array
    : '[' values optional_comma ']'                 { result = val[1]}
    | '[' reference ',' values optional_comma ']'   { result = val[3].unshift(val[1])}
    | '[' reference optional_comma ']'              { result = [val[1]] }
    | '[' ']'                                       { result = []}
  ;

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

  values
    : values ',' value                              { result = val[0] << val[2]}
    | values ',' reference                          { result = val[0] << val[2]}
    | value                                         { result = [val[0]]}
  ;

	assignment
    : literal '=' expression selector               { assign(val[0], val[2], val[3])}
  ;

	connection
    : literal '=' literal selector                  { connect(val[0], val[2], val[3])}
  ;

	include_file
    : INCLUDE string 													      { include_file(val[1])}
    | INCLUDE string INTO SCOPE                     { include_file(val[1], val[3])}
  ;

  parameter
    : scalar
  ;

  parameters
    : parameters ',' parameter                      { result = val[0] << val[2]}
    | parameter                                     { result = [val[0]]}
  ;

  datasource
    : literal '(' parameters ')'                     { result = [val[0], val[2]]} 
    | literal                                        { result = [val[0], []]}
    ;

  imported_name
    : '*'
    | literal
    | SCOPE '*'                                       {result = "#{val[0]}*"}
    | string
    ;


  import_data
    : IMPORT imported_name FROM datasource INTO SCOPE       { import(val[1], val[5], val[3][0], val[3][1])}
    | IMPORT imported_name FROM datasource                  { import(val[1], nil, val[3][0], val[3][1])}
  ;


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
