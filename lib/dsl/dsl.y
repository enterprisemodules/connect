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
    | default_scope
  ;

  scope
    :
    | SCOPE
  ;

  selector
    :
    | SELECTOR
  ;

  with_scope_do
    : WITH SCOPE DO                 { push_scope(val[1])}
    ;

  with_scope_bracket                
    : WITH SCOPE '{'                { push_scope(val[1])}
    ;


  default_scope
    : with_scope_do dsl END           { pop_scope }
    | with_scope_bracket dsl '}'      { pop_scope }
  ;


  literal
    : scope IDENTIFIER                         { result = "#{val[0]}#{val[1]}"}
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

  definition
    : literal '(' string ')' iterator block 
                                                    { result = define(val[0], val[2], val[5], val[4])}
  ;

  block
    : 
    | '{' hashpairs optional_comma '}'              { result = val[1]}
    | DO hashpairs optional_comma END               { result = val[1]}
  ;

  iterator
    :
    | FROM INTEGER TO INTEGER                       { result = {:from => val[1], :to => val[3]}}
  ;

end

---- header
  require 'dsl/dsl'
  require 'dsl/lexer'

---- inner

  def parse(input)
    scan_str(input)
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

