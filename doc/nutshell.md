# The connect language in a nutshell

This file contains an overview of the connect language. It contains short snippets and is mainly intended to get you up to speed quickly.

## Commenting

Just like in Ruby and Puppet, you can comment your code using `#`. The `#` can start at the beginning of a line, to make the whole line a comment, or you can append the `#` to some statements to comment this line of code.

```
#
# This is a full line of comments
#
a = 10  # This is some comment at the end of a statement
```

## Variable names

The variable naming system is based on the [puppet namespace syntax](https://docs.puppetlabs.com/puppet/latest/reference/lang_namespaces.html#syntax). A variable has can have an unqualified name:

```
unqualified_name = 10
```

Variable names can also contain a scope. Scopes are specified by using double colon's (`::`)

```
scope1::scope2::name = 10
``` 

A qualified name including two scopes, namely `scope1::` and `scope2::`

Puppet automatic parameter binding, maps directly to this use of scope. If you are using `hiera(...)` calls to lookup values, you have to make sure, you use the same colon system. This will cause problems:

```
scope:faulty_variable_name = 10 # Using a single colon
```

## Assigning scalar values

To assign a scalar value to a variable, use the `=`

```
my_string = 'a string'
my_string = "a string"
my_int    = 10
my_float  = 10.5
```

Like regular programming languages, you can assign a variable multiple times. The last assigned value, is the value that will be passed back on a lookup.

```
my_value = 10   # Now my_value is 10
my_value = 20   # And now it is 20. Any connections to my_value, will also be 20 
```

## Connecting variables

The concept of connecting variables is easy. In fact so easy, in any programming language we just talk about assigning. In Connect it is the same. To connect two variables, we just use assignments.

```
my_variable   = 10
my_connection = my_variable  # This means my_connection will be 10
```

If the original value, is reassigned, the connected value will also change.

```
my_variable   = 10
my_connection = my_variable
my_variable   = 20          # This means my_connection will also be 20
```

## Array's

To construct an array in Connect, use the `[` and `]`.

```
my_integer_array = [1,2,3,4,5]
my_string_array  = ['a','b','c']
```

Because the underlying Ruby type system, you can mix data types in an array.

```
my_mixed_array = [1, 'a', 2, 'b']
```

To make it easy to extend ranges, you can use a trailing `,` in arrays. You can  also spread the assignment over multiple lines.

```
array_with_trailing_comma = [
  1,
  2,
]
```

Arrays can use connections (e.g. references to other variables).

```
value = 10
array_with_connections = [
  value,
  20,
] # will result in [10,20]
```

## Hashes

To construct a Hash in Connect, you can use either `{` and `}`, or `do` and `end`. Hash entries must be separated with a `,`.

```
# A Hash using { and }
my_hash = {
  a: 10,
  b: 'a string'
} # This translates in to Ruby {'a' => 10, 'b' => 'a string'}


# A Hash using do and end
my_hash = do
  a: 10,
  b: 20
end # This translates in to Ruby {'a' => 10, 'b' => 'a string'}
```

Within a hash pair, you can use colon's (e.g. `:`) or the traditional ruby hash rocket (e.g. `=>`). Whatever suits you best. 

```
# A Hash using hash rockets
my_hash = {
  a => 10,
  b => 'a string'
} # This translates in to Ruby {'a' => 10, 'b' => 'a string'}

```

To make it easy to extend Hashes, you can use trailing `,`.

```
my_hash_with_trailing_comma = {
  a => 10,
  b => 'a string',
} 
```
 Just like in array's, hashes can reference other variables.

```
my_value = 10
my_hash_with_reference = {
  a => my_value,
  b => 'a string',
} 
```



## include

Sometimes you would like to split your configuration files into multiple files and include them. 

```
include 'settings'            # Include's a single file in the default
                              # directory, with extension .config

include 'my_domain/settings'  # include a single file in the subdirectory of
                              # of the default directory, using the extension
                              # .config

include '/an/absolute/path'   # include a single file at the specified directory
                              # using the default extension .config

include 'my_settings/*'       # include all config files in the settings
                              # directory

```

If you would like to include all values into a specified scope, you can use the `include into` statement.

```
include `settings` into settings::
```

This statement means the file `settings.config` is included, and all non-scoped variables are put into the scope `settings::`. Check (`with`) for more information.

## with

One of the mechanisms to ensure variables are not overwritten by accident is scoping. In Connect, scopes are specified using double colons (`::`). When you are providing a set of variables in a specified scope, you can use the scope features of Connect. The `include` and `with` keywords manage scope. 

Using these keywords, you can make sure any unscoped variables are put into the specified scope. When a scope is specified, it will be preferred over the specified default scope. 

```
with my_scope:: do
  variable_1             = 10   # my_scope::variable_1 = 10
  with_scope::variable_2 = 20   # with_scope::variable_2 = 20
end 
```

You can stack defaults scopes:

```
with my_first_scope:: do
  variable_1 = 10           # my_first_scope::variable_1 = 10
  with my_second_scope do
    variable_2 = 20         # my_first_scope::my_second_scope::variable_2 = 20
  end
end
```

## Objects

Using `create_resource` and `ensure_resource` , Puppet has the means to create resources based on a hash.  These hashes need to be structured in a certain way. Connect makes it easy to build those hashes.

### defining objects

```
an_object(my_object_name) {
  property_1: 10,
  property_2: 20,
}
```
This defines an object of type `an_object` and name `my_object_name`. If the name contains only characters, and numbers and underscores, there is no need to put quote's around the name. If your name contains other characters, you must use quotes:

```
an_object('my.host.name.com') {
  property_1: 10,
  property_2: 20,
}
```

The type can be anything you want, as long as it only includes characters, numbers, and underscores.

```
an_rediculous_type_of_object('my.host.name.com') {
  property_1: 10,
  property_2: 20,
}
```
You can overwrite object properties.

```
object = my_object('foo') {
  property_1: 10,
  property_2: 20,
  ...
}

#
# Object foo.property_1 is 10
#

object = my_object('foo') {
  property_1: 20,
  ...
}

#
# Object foo.property_2 is now 20
#
```

This behavior can be useful when you want to override standard settings included in a default file.

### Using objects

You can use these objects in regular assignments:

```
value = an_object('my_object_name') # value will be {'my_object_name' => {'property_1' => 10, 'property_2' => 20}}
```

And in arrays or hashes:

```
values = [
  an_object(obj_1),
  an_object(obj_2),
]

hashes = [
  my_key: an_object('my_object_name'),
]

```

If you want to merge a set of object hashes, use:

```
big_hash = {
  an_object('object_1'),
  an_object('object_2'),
  an_object('object_3'),
  an_object('object_4'),
}
```
