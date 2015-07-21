#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'

  require 'connect/extended_array'
  require 'connect/dsl'
  require 'connect/lexer'

module Connect
  class Dsl < Racc::Parser

module_eval(<<'...end dsl.y/module_eval...', 'dsl.y', 287)

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
    position =  "Syntax error around line #{lineno} of config file '#{current_file}'"
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
...end dsl.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    17,   161,     9,    10,    36,    37,     9,    10,     4,   144,
     9,    10,     4,   147,     9,    10,     4,   -96,   -96,   148,
     4,    36,    37,    39,    40,    36,    37,   141,   -96,   -96,
   102,    11,    24,    25,    14,    11,    16,   140,    14,    11,
    16,   142,    14,    11,    16,   -96,    14,   -96,    16,   137,
   130,   138,   172,   137,   125,   138,   -96,   142,   -96,     9,
    46,    42,    43,    44,    45,     9,    27,    60,   155,   124,
    24,    25,    49,    50,   142,    87,    24,    25,    88,   121,
    59,   143,     9,    27,    36,    37,   165,     9,    46,    42,
    43,    44,    45,    24,    25,    60,     9,    27,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,    91,
    60,     9,    27,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,    87,    60,   120,    88,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,    87,
    60,   104,    88,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,   126,    60,   127,    99,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,   145,
    60,    39,    40,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,    74,    60,    36,    37,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,    69,
    60,     9,    27,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,    68,    60,    70,    71,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,    65,
    60,    72,    73,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,    62,    60,    24,    25,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,   166,
    60,   167,   124,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,   169,    60,   170,   171,    24,    25,
    49,    50,     9,    46,    42,    43,    44,    45,    59,    33,
    60,   173,    32,    24,    25,    49,    50,     9,    46,    42,
    43,    44,    45,    59,    23,    60,     9,    27,    24,    25,
    49,    50,    79,    78,    21,    39,    40,   177,    59,     9,
    27,     9,    27,   182,    75,    76,    77,    80,    81,    87,
    24,    25,    88,    95,    42,    43,    44,    45,   179,   180,
   181,    20,    93,    24,    25,    49,    50,    95,    42,    43,
    44,    45,    95,    42,    43,    44,    45,    24,    25,    49,
    50,    19,    24,    25,    49,    50,     9,    27,    42,    43,
    44,    45,   179,   nil,   nil,   nil,   nil,    24,    25,     9,
    27,    42,    43,    44,    45,   nil,   nil,   nil,   nil,   nil,
    24,    25,     9,    27,    42,    43,    44,    45,   nil,   nil,
   nil,   nil,   nil,    24,    25,     9,    27,    42,    43,    44,
    45,     9,    27,   nil,   nil,   nil,    24,    25,   nil,   nil,
    39,    40 ]

racc_action_check = [
     1,   138,     1,     1,    66,    66,     0,     0,     1,   118,
    12,    12,     0,   122,    22,    22,    12,   141,   141,   123,
    22,   106,   106,    22,    22,   105,   105,   108,   140,   140,
    66,     1,    14,    14,     1,     0,     1,   107,     0,    12,
     0,   164,    12,    22,    12,   141,    22,   141,    22,   106,
   102,   106,   164,   105,    95,   105,   140,   132,   140,   145,
   145,   145,   145,   145,   145,    74,    74,   145,   132,    92,
   145,   145,   145,   145,   117,   129,    74,    74,   129,    89,
   145,   117,   125,   125,   130,   130,   145,    59,    59,    59,
    59,    59,    59,   125,   125,    59,   103,   103,    59,    59,
    59,    59,    76,    76,    76,    76,    76,    76,    59,    59,
    76,    15,    15,    76,    76,    76,    76,    87,    87,    87,
    87,    87,    87,    76,    82,    87,    88,    82,    87,    87,
    87,    87,   128,   128,   128,   128,   128,   128,    87,    98,
   128,    67,    98,   128,   128,   128,   128,    23,    23,    23,
    23,    23,    23,   128,    97,    23,    97,    62,    23,    23,
    23,    23,    81,    81,    81,    81,    81,    81,    23,   120,
    81,   168,   168,    81,    81,    81,    81,    78,    78,    78,
    78,    78,    78,    81,    46,    78,    21,    21,    78,    78,
    78,    78,   144,   144,   144,   144,   144,   144,    78,    35,
   144,    32,    32,   144,   144,   144,   144,    75,    75,    75,
    75,    75,    75,   144,    34,    75,    44,    44,    75,    75,
    75,    75,   142,   142,   142,   142,   142,   142,    75,    31,
   142,    45,    45,   142,   142,   142,   142,   104,   104,   104,
   104,   104,   104,   142,    26,   104,    65,    65,   104,   104,
   104,   104,    79,    79,    79,    79,    79,    79,   104,   150,
    79,   151,   156,    79,    79,    79,    79,    80,    80,    80,
    80,    80,    80,    79,   160,    80,   161,   163,    80,    80,
    80,    80,    77,    77,    77,    77,    77,    77,    80,    17,
    77,   165,    16,    77,    77,    77,    77,   121,   121,   121,
   121,   121,   121,    77,    13,   121,    29,    29,   121,   121,
   121,   121,    58,    58,    11,    29,    29,   173,   121,    20,
    20,   179,   179,   179,    58,    58,    58,    58,    58,    58,
    20,    20,    58,    60,    60,    60,    60,    60,   175,   176,
   177,    10,    60,    60,    60,    60,    60,   124,   124,   124,
   124,   124,   135,   135,   135,   135,   135,   124,   124,   124,
   124,     9,   135,   135,   135,   135,   169,   169,   169,   169,
   169,   169,   184,   nil,   nil,   nil,   nil,   169,   169,   137,
   137,   137,   137,   137,   137,   nil,   nil,   nil,   nil,   nil,
   137,   137,   170,   170,   170,   170,   170,   170,   nil,   nil,
   nil,   nil,   nil,   170,   170,   180,   180,   180,   180,   180,
   180,   131,   131,   nil,   nil,   nil,   180,   180,   nil,   nil,
   131,   131 ]

racc_action_pointer = [
     4,     0,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   358,
   314,   312,     8,   271,    19,   109,   255,   289,   nil,   nil,
   317,   177,    12,   145,   nil,   nil,   209,   nil,   nil,   304,
   nil,   196,   199,   nil,   186,   171,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   212,   227,   157,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   306,    85,
   330,   nil,   155,   nil,   nil,   233,    -5,   114,   nil,   nil,
   nil,   nil,   nil,   nil,    63,   205,   100,   280,   175,   250,
   265,   160,   101,   nil,   nil,   nil,   nil,   115,   123,    62,
   nil,   nil,    52,   nil,   nil,    27,   nil,   124,   116,   nil,
   nil,   nil,    48,    94,   235,    16,    12,     9,    -1,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    57,   -16,   nil,
   142,   295,   -11,     7,   344,    80,   nil,   nil,   130,    52,
    75,   409,    40,   nil,   nil,   349,   nil,   377,    -2,   nil,
    19,     8,   220,   nil,   190,    57,   nil,   nil,   nil,   nil,
   231,   233,   nil,   nil,   nil,   nil,   245,   nil,   nil,   nil,
   236,   239,   nil,   253,    24,   261,   nil,   nil,   160,   364,
   390,   nil,   nil,   314,   nil,   298,   301,   312,   nil,   319,
   403,   nil,   nil,   nil,   332,   nil ]

racc_action_default = [
  -103,  -103,    -1,    -9,   -10,   -11,   -12,   -13,   -14,  -103,
   -20,  -103,  -103,  -103,  -103,  -103,  -103,  -103,    -2,   -19,
  -103,  -103,  -103,  -103,   -21,   -22,   -79,   -20,   -81,  -103,
   -89,  -103,  -103,   186,  -103,  -103,   -15,   -16,   -61,   -17,
   -18,   -62,    -3,    -4,  -103,  -103,   -20,   -23,   -24,   -25,
   -26,   -30,   -31,   -32,   -33,   -34,   -35,   -41,   -50,  -103,
  -103,   -78,  -103,   -84,   -88,  -103,  -103,   -87,   -96,   -96,
    -5,    -6,    -7,    -8,  -103,  -103,  -103,  -103,  -103,  -103,
  -103,  -103,   -49,   -52,   -53,   -54,   -55,  -103,  -103,   -67,
   -37,   -64,   -67,   -66,   -69,   -71,   -72,  -103,   -76,   -80,
   -90,   -82,  -103,  -103,  -103,  -103,  -103,  -103,  -103,   -42,
   -43,   -44,   -45,   -46,   -47,   -48,   -51,  -103,   -39,   -40,
   -58,   -68,  -103,  -103,   -68,  -103,   -73,   -74,  -103,   -77,
  -103,  -103,  -103,   -39,   -91,  -103,   -97,  -103,  -103,   -92,
   -94,   -93,  -103,   -56,  -103,  -103,   -36,   -63,   -65,   -70,
  -103,  -103,   -75,   -83,   -85,   -86,   -67,   -27,   -28,   -29,
  -103,  -103,   -38,  -103,  -103,  -103,   -93,   -94,  -103,  -103,
  -103,   -57,   -59,  -103,   -95,  -100,  -103,  -103,   -98,  -103,
  -103,   -60,  -101,  -102,  -100,   -99 ]

racc_goto_table = [
    26,    41,    13,    13,    38,    29,    34,    64,    63,    61,
    92,    96,   106,    98,    13,   122,   117,    31,   123,   116,
   158,   178,    35,   118,    13,   160,    18,    82,     1,   159,
   185,    31,   149,   132,    67,   134,   139,   101,    89,    66,
    22,    28,     7,     7,   128,    90,   nil,    18,   nil,   103,
   nil,   100,   158,   158,     7,   nil,   nil,   175,   176,   nil,
   107,   159,   159,   158,     7,   nil,   116,   129,   184,   nil,
   nil,   183,   159,   nil,   164,    96,   108,    98,   162,   nil,
   163,   nil,   168,   nil,   106,   156,    96,   nil,    98,   nil,
   nil,   nil,   nil,   131,   109,   110,   111,   112,   113,   114,
   115,   nil,   nil,   nil,   nil,    31,   nil,   146,   nil,    64,
   154,   151,   nil,   153,   152,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   157,   nil,   nil,   nil,   150,   nil,   nil,
   nil,   nil,   nil,    31,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   174,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   157,   157,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   157 ]

racc_goto_check = [
    12,    10,    11,    11,     9,    39,    12,    40,    10,    21,
    31,    13,    41,    19,    11,    30,    22,    11,    30,    25,
     3,    44,    11,    23,    11,    14,     2,    24,     1,    15,
    44,    11,    32,    22,    11,    42,    42,    38,    20,    37,
     1,    36,     7,     7,    34,    21,   nil,     2,   nil,     9,
   nil,    12,     3,     3,     7,   nil,   nil,    14,    14,   nil,
    12,    15,    15,     3,     7,   nil,    25,    24,    14,   nil,
   nil,    15,    15,   nil,    22,    13,    11,    19,    23,   nil,
    23,   nil,    30,   nil,    41,    31,    13,   nil,    19,   nil,
   nil,   nil,   nil,    39,    16,    16,    16,    16,    16,    16,
    16,   nil,   nil,   nil,   nil,    11,   nil,    21,   nil,    40,
    10,    12,   nil,     9,    21,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    12,   nil,   nil,   nil,    11,   nil,   nil,
   nil,   nil,   nil,    11,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    10,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    12,    12,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    12 ]

racc_goto_pointer = [
   nil,    28,    25,  -117,   nil,   nil,   nil,    42,   nil,   -17,
   -21,     2,   -14,   -49,  -112,  -108,    19,   nil,   nil,   -47,
   -21,   -14,   -71,   -64,   -31,   -63,   nil,   nil,   nil,   nil,
   -74,   -50,   -92,   nil,   -53,   nil,    26,     7,   -29,   -10,
   -22,   -57,   -70,   nil,  -154 ]

racc_goto_default = [
   nil,   nil,     2,    48,     3,     5,     6,    54,     8,   135,
   nil,    57,    47,    51,   nil,    56,    58,    52,    53,    55,
   nil,   119,   nil,   133,   nil,    83,    84,    85,    86,    12,
   nil,   nil,    94,    97,   nil,    15,   nil,   nil,   nil,   nil,
    30,   105,   nil,   136,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 42, :_reduce_none,
  2, 42, :_reduce_none,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  2, 44, :_reduce_5,
  2, 44, :_reduce_6,
  2, 44, :_reduce_7,
  2, 44, :_reduce_8,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 50, :_reduce_none,
  1, 50, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  2, 52, :_reduce_19,
  1, 52, :_reduce_20,
  1, 53, :_reduce_21,
  1, 53, :_reduce_none,
  1, 54, :_reduce_none,
  1, 54, :_reduce_none,
  1, 54, :_reduce_none,
  1, 54, :_reduce_none,
  1, 55, :_reduce_none,
  1, 55, :_reduce_none,
  1, 55, :_reduce_none,
  1, 57, :_reduce_none,
  1, 57, :_reduce_none,
  1, 57, :_reduce_none,
  1, 57, :_reduce_none,
  1, 57, :_reduce_none,
  1, 57, :_reduce_none,
  3, 61, :_reduce_36,
  1, 61, :_reduce_37,
  3, 63, :_reduce_38,
  1, 63, :_reduce_39,
  1, 64, :_reduce_none,
  1, 56, :_reduce_41,
  3, 62, :_reduce_42,
  3, 62, :_reduce_43,
  3, 62, :_reduce_44,
  3, 62, :_reduce_45,
  3, 62, :_reduce_46,
  3, 62, :_reduce_47,
  3, 62, :_reduce_48,
  2, 62, :_reduce_49,
  1, 62, :_reduce_none,
  2, 65, :_reduce_51,
  1, 65, :_reduce_none,
  1, 66, :_reduce_none,
  1, 66, :_reduce_none,
  1, 66, :_reduce_none,
  3, 67, :_reduce_56,
  5, 67, :_reduce_57,
  2, 68, :_reduce_58,
  5, 68, :_reduce_59,
  7, 69, :_reduce_60,
  3, 70, :_reduce_61,
  3, 49, :_reduce_62,
  4, 58, :_reduce_63,
  2, 58, :_reduce_64,
  4, 59, :_reduce_65,
  2, 59, :_reduce_66,
  0, 71, :_reduce_none,
  1, 71, :_reduce_none,
  1, 72, :_reduce_none,
  3, 72, :_reduce_70,
  1, 74, :_reduce_71,
  1, 74, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  3, 73, :_reduce_75,
  1, 73, :_reduce_76,
  2, 73, :_reduce_77,
  3, 45, :_reduce_78,
  2, 46, :_reduce_79,
  4, 46, :_reduce_80,
  2, 47, :_reduce_none,
  4, 47, :_reduce_none,
  6, 76, :_reduce_83,
  2, 77, :_reduce_84,
  3, 79, :_reduce_none,
  4, 78, :_reduce_86,
  1, 78, :_reduce_87,
  2, 80, :_reduce_none,
  1, 80, :_reduce_none,
  3, 81, :_reduce_90,
  6, 48, :_reduce_91,
  6, 48, :_reduce_92,
  4, 60, :_reduce_93,
  4, 60, :_reduce_94,
  4, 83, :_reduce_95,
  0, 82, :_reduce_none,
  2, 82, :_reduce_97,
  5, 84, :_reduce_98,
  7, 84, :_reduce_99,
  0, 85, :_reduce_100,
  2, 85, :_reduce_101,
  2, 85, :_reduce_102 ]

racc_reduce_n = 103

racc_shift_n = 186

racc_token_table = {
  false => 0,
  :error => 1,
  :SCOPE => 2,
  :IDENTIFIER => 3,
  :INTEGER => 4,
  :FLOAT => 5,
  "-" => 6,
  "+" => 7,
  :connection => 8,
  :DO => 9,
  "{" => 10,
  :END => 11,
  "}" => 12,
  :DOUBLE_QUOTED => 13,
  :SINGLE_QUOTED => 14,
  :BOOLEAN => 15,
  :UNDEF => 16,
  "," => 17,
  "^" => 18,
  "*" => 19,
  "/" => 20,
  :OR => 21,
  :AND => 22,
  "[" => 23,
  "]" => 24,
  :DOUBLE_DOTS => 25,
  "." => 26,
  "(" => 27,
  ")" => 28,
  "&" => 29,
  ":" => 30,
  :WITH => 31,
  :HASH_ROCKET => 32,
  "=" => 33,
  :INCLUDE => 34,
  :INTO => 35,
  :IMPORT => 36,
  :FROM => 37,
  :TO => 38,
  :ITERATE => 39,
  :STEP => 40 }

racc_nt_base = 41

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "SCOPE",
  "IDENTIFIER",
  "INTEGER",
  "FLOAT",
  "\"-\"",
  "\"+\"",
  "connection",
  "DO",
  "\"{\"",
  "END",
  "\"}\"",
  "DOUBLE_QUOTED",
  "SINGLE_QUOTED",
  "BOOLEAN",
  "UNDEF",
  "\",\"",
  "\"^\"",
  "\"*\"",
  "\"/\"",
  "OR",
  "AND",
  "\"[\"",
  "\"]\"",
  "DOUBLE_DOTS",
  "\".\"",
  "\"(\"",
  "\")\"",
  "\"&\"",
  "\":\"",
  "WITH",
  "HASH_ROCKET",
  "\"=\"",
  "INCLUDE",
  "INTO",
  "IMPORT",
  "FROM",
  "TO",
  "ITERATE",
  "STEP",
  "$start",
  "dsl",
  "config",
  "number",
  "assignment",
  "include",
  "import",
  "object_definition",
  "with",
  "block_begin",
  "block_end",
  "literal",
  "string",
  "scalar",
  "string_number_reference",
  "reference",
  "value",
  "array",
  "hash",
  "object_reference",
  "values",
  "expression",
  "parameters",
  "parameter",
  "selectors",
  "selector",
  "array_selector",
  "function_selector",
  "special_selector",
  "with_scope_do",
  "optional_comma",
  "hashpairs",
  "hashpair",
  "hashkey",
  "hash_seperator",
  "import_with_scope_begin",
  "import_with_scope_end",
  "datasource",
  "import_block",
  "import_statements",
  "import_statement",
  "iterators",
  "definition_block",
  "iterator",
  "step" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

# reduce 4 omitted

module_eval(<<'.,.,', 'dsl.y', 17)
  def _reduce_5(val, _values, result)
     result = 0 - val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 18)
  def _reduce_6(val, _values, result)
     result = 0 - val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 19)
  def _reduce_7(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 20)
  def _reduce_8(val, _values, result)
     result = val[1]
    result
  end
.,.,

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

# reduce 15 omitted

# reduce 16 omitted

# reduce 17 omitted

# reduce 18 omitted

module_eval(<<'.,.,', 'dsl.y', 46)
  def _reduce_19(val, _values, result)
     result = "#{val[0]}#{val[1]}"
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 47)
  def _reduce_20(val, _values, result)
     result = "#{val[0]}"
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 51)
  def _reduce_21(val, _values, result)
     result = interpolate(val[0], xref)
    result
  end
.,.,

# reduce 22 omitted

# reduce 23 omitted

# reduce 24 omitted

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

# reduce 28 omitted

# reduce 29 omitted

# reduce 30 omitted

# reduce 31 omitted

# reduce 32 omitted

# reduce 33 omitted

# reduce 34 omitted

# reduce 35 omitted

module_eval(<<'.,.,', 'dsl.y', 79)
  def _reduce_36(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 80)
  def _reduce_37(val, _values, result)
     result = ExtendedArray[val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 84)
  def _reduce_38(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 85)
  def _reduce_39(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

# reduce 40 omitted

module_eval(<<'.,.,', 'dsl.y', 93)
  def _reduce_41(val, _values, result)
    result = reference(val[0], xref)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 97)
  def _reduce_42(val, _values, result)
     result = power(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 98)
  def _reduce_43(val, _values, result)
     result = multiply(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 99)
  def _reduce_44(val, _values, result)
     result = divide(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 100)
  def _reduce_45(val, _values, result)
     result = add(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 101)
  def _reduce_46(val, _values, result)
     result = subtract(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 102)
  def _reduce_47(val, _values, result)
     result = do_or(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 103)
  def _reduce_48(val, _values, result)
     result = do_and(val[0],val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 104)
  def _reduce_49(val, _values, result)
     result = selector(val[0], val[1])
    result
  end
.,.,

# reduce 50 omitted

module_eval(<<'.,.,', 'dsl.y', 112)
  def _reduce_51(val, _values, result)
     result = val.join
    result
  end
.,.,

# reduce 52 omitted

# reduce 53 omitted

# reduce 54 omitted

# reduce 55 omitted

module_eval(<<'.,.,', 'dsl.y', 123)
  def _reduce_56(val, _values, result)
     result = "[#{to_param(val[1])}]" 
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 124)
  def _reduce_57(val, _values, result)
     result = "[#{to_param(val[1])}..#{to_param(val[3])}]" 
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 128)
  def _reduce_58(val, _values, result)
     result = val.join
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 129)
  def _reduce_59(val, _values, result)
     result = val[0] + val[1] + val[2] + to_param(val[3]) +  val[4]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 133)
  def _reduce_60(val, _values, result)
     result = val.join
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 140)
  def _reduce_61(val, _values, result)
     push_scope(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 144)
  def _reduce_62(val, _values, result)
     pop_scope 
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 151)
  def _reduce_63(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 152)
  def _reduce_64(val, _values, result)
     result = ExtendedArray[]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 159)
  def _reduce_65(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 160)
  def _reduce_66(val, _values, result)
     result = MethodHash.new
    result
  end
.,.,

# reduce 67 omitted

# reduce 68 omitted

# reduce 69 omitted

module_eval(<<'.,.,', 'dsl.y', 170)
  def _reduce_70(val, _values, result)
     result.merge!(val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 174)
  def _reduce_71(val, _values, result)
     result = val[0]
    result
  end
.,.,

# reduce 72 omitted

# reduce 73 omitted

# reduce 74 omitted

module_eval(<<'.,.,', 'dsl.y', 184)
  def _reduce_75(val, _values, result)
     result = MethodHash[val[0], val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 185)
  def _reduce_76(val, _values, result)
     result = MethodHash[val[0].object_id, val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 186)
  def _reduce_77(val, _values, result)
     selector(val[0], val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 193)
  def _reduce_78(val, _values, result)
     assign(val[0], val[2], xdef)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 201)
  def _reduce_79(val, _values, result)
     include_file(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 202)
  def _reduce_80(val, _values, result)
     include_file(val[1], val[3])
    result
  end
.,.,

# reduce 81 omitted

# reduce 82 omitted

module_eval(<<'.,.,', 'dsl.y', 214)
  def _reduce_83(val, _values, result)
     push_scope(val[4])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 218)
  def _reduce_84(val, _values, result)
     pop_scope
    result
  end
.,.,

# reduce 85 omitted

module_eval(<<'.,.,', 'dsl.y', 225)
  def _reduce_86(val, _values, result)
     datasource( val[0], *val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 226)
  def _reduce_87(val, _values, result)
     datasource( val[0], *[])
    result
  end
.,.,

# reduce 88 omitted

# reduce 89 omitted

module_eval(<<'.,.,', 'dsl.y', 235)
  def _reduce_90(val, _values, result)
     import(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 243)
  def _reduce_91(val, _values, result)
     result = define_object(val[0], val[2], val[5], val[4], xdef)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 245)
  def _reduce_92(val, _values, result)
     result = define_object(val[0], lookup_value(val[2]), val[5], val[4], xdef)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 250)
  def _reduce_93(val, _values, result)
     result = reference_object(val[0], lookup_value(val[2]), xref)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 251)
  def _reduce_94(val, _values, result)
     result = reference_object(val[0], val[2], xref)
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 257)
  def _reduce_95(val, _values, result)
     result = val[1]
    result
  end
.,.,

# reduce 96 omitted

module_eval(<<'.,.,', 'dsl.y', 262)
  def _reduce_97(val, _values, result)
     result = val[0].nil? ? val[1] : val[0].merge!(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 267)
  def _reduce_98(val, _values, result)
     result = {'iterator' => {:from => val[1], :to => val[3], :step => val[4]}}
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 269)
  def _reduce_99(val, _values, result)
     result = {val[1] => {:from => val[3], :to => val[5], :step => val[6]}}
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 273)
  def _reduce_100(val, _values, result)
     result = 1 
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 274)
  def _reduce_101(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'dsl.y', 275)
  def _reduce_102(val, _values, result)
     result = val[1]
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class Dsl
  end   # module Connect
