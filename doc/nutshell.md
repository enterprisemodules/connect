#The connect language in a nutshell

This file contains an overview of the connect language. It contains short snippets and is mainly intended to get you up to speed quickly.

1. [Commenting](#commenting)
2. [Variable names](#variable-names)
3. [Assigning scalar values](#assigning-scalar-values)
4. [Connecting variables](#connecting-variables)
5. [String Interpolation](#string-interpolation)
6. [Arrays](#arrays)
7. [Hashes](#hashes)
8. [include statement](#include-statement)
9. [with statement](#with-statement)
10. [Objects](#objects)
    * [Using objects](#using-objects)
11. [Selectors](#selectors)
    * [Special selectors](#special-selectors)
      * [extract](#extract)
      * [to_resource](#to_resource)
12. [importing data](#importing-data)
13. [Ordering](#ordering)

##Commenting

Just like in Ruby and Puppet, you can comment your code using `#`. The `#` can start at the beginning of a line, to make the whole line a comment. You can also append the `#` to some statements to comment this line of code.

```ruby
#
# This is a full line of comments
#
a = 10  # This is some comment at the end of a statement
```

##Variable names

The variable naming system is based on the [puppet namespace syntax](https://docs.puppetlabs.com/puppet/latest/reference/lang_namespaces.html#syntax). A variable has can have an unqualified name:

```ruby
unqualified_name = 10
```

Variable names can also contain a scope. Scopes are specified by using double colon's (`::`)

```ruby
scope1::scope2::name = 10
``` 

A qualified name including two scopes, namely `scope1::` and `scope2::`

Puppet automatic parameter binding, maps directly to this use of scope. If you are using `hiera(...)` calls to lookup values, you have to make sure, you use the same double colon system. 

If you use something else, you might run into trouble. This, for example, will cause problems:

```ruby
scope:faulty_variable_name = 10 # Using a single colon
```

##Assigning scalar values

To assign a scalar value to a variable, use the `=`

```ruby
my_string = 'a string'
my_string = "a string"
my_int    = 10
my_float  = 10.5
```

Like regular programming languages, you can assign a variable multiple times. The last assigned value, is the value that will be passed back on a lookup.

```ruby
my_value = 10   # Now my_value is 10
my_value = 20   # And now it is 20. Any connections to my_value, will also be 20 
```

##Connecting variables

The concept of connecting variables is easy. In fact so easy, in any programming language we just talk about assigning. In Connect it is the same. To connect two variables, we just use assignments.

```ruby
my_variable   = 10
my_connection = my_variable  # This means my_connection will be 10
```

If the original value, is reassigned, the connected value will also change.

```ruby
my_variable   = 10
my_connection = my_variable
my_variable   = 20          # This means my_connection will also be 20
```

##String interpolation

Strings in double quotes are interpolated. Strings using single quotes are not interpellated.The Connect interpolator knows about its own variables, and it knows about Puppet variables. Let's first interpolate some Connect variables.

```ruby
my_name   = 'Bert'
greetings = "Hello ${my_name}"   # Will be "Hello Bert"
strange   = 'Hello ${my_name}'   # Will be "Hello ${my_name}"
```

Connect also knows how to interpolate Puppet variables:

```ruby
welcome_text = "Welcome on host %{::hostname}"
                              # Will be: "Welcome on host host1"
```
To allow Connect, to interpolate a Puppet variable, it must be defined in Puppet first. Because most of the times the Connect configuration is parsed before running the big parts of Puppet, you can safely reference fact's. If you want to reference other Puppet variables, you must ensure, they are defined early in the Puppet parsing process (e.g. at the beginning of the `site.pp` for example).

##Arrays

To construct an array in Connect, use the `[` and `]`.

```ruby
my_integer_array = [1,2,3,4,5]
my_string_array  = ['a','b','c']
```

Because underlying type system is based on Ruby, you can mix data types in an array.

```ruby
my_mixed_array = [1, 'a', 2, 'b']
```

You can use a trailing `,` in arrays. You can  also write the assignment over multiple lines.

```ruby
array_with_trailing_comma = [
  1,
  2,
]
```

Arrays can use connections (e.g. references to other variables).

```ruby
value = 10
array_with_connections = [
  value,
  20,
] # will result in [10,20]
```

##Hashes

To construct a Hash in Connect, you can use either `{` and `}`, or `do` and `end`. Hash entries must be separated with a `,`.

```ruby
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

```ruby
# A Hash using hash rockets
my_hash = {
  a => 10,
  b => 'a string'
} # This translates in to Ruby {'a' => 10, 'b' => 'a string'}

```

You can use trailing `,` if you like.

```ruby
my_hash_with_trailing_comma = {
  a => 10,
  b => 'a string',
} 
```
 Just like in array's, hashes can reference other variables.

```ruby
my_value = 10
my_hash_with_reference = {
  a => my_value,
  b => 'a string',
} 
```

##include statement

Sometimes you would like to split your configuration files into multiple files and include them. 

```ruby
include 'settings'            # Includes a single file in the default
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

```ruby
include `settings` into settings::
```

This statement means the file `settings.config` is included, and all non-scoped variables are put into the scope `settings::`. Check (`with`) for more information.

##with statement

One of the mechanisms to ensure variables are not overwritten by accident is scoping. In Connect, scopes are specified using double colons (`::`). When you are providing a set of variables in a specified scope, you can use the scope features of Connect. The `include` and `with` keywords manage scope. 

Using these keywords, you can make sure any unscoped variables are put into the specified scope. When a scope is specified, it will be preferred over the specified default scope. 

```ruby
with my_scope:: do
  variable_1             = 10   # my_scope::variable_1 = 10
  with_scope::variable_2 = 20   # with_scope::variable_2 = 20
end 
```

You can stack defaults scopes:

```ruby
with my_first_scope:: do
  variable_1 = 10           # my_first_scope::variable_1 = 10
  with my_second_scope do
    variable_2 = 20         # my_first_scope::my_second_scope::variable_2 = 20
  end
end
```

##Objects

Using `create_resource` and `ensure_resource` , Puppet has the means to create resources based on a hash.  These hashes need to be structured in a certain way. Connect makes it easy to build those hashes.

###Defining objects

```ruby
an_object(my_object_name) {
  property_1: 10,
  property_2: 20,
}
```

This defines an object of type `an_object` and name `my_object_name`. If the name contains only characters, and numbers and underscores, there is no need to put quote's around the name. If your name contains other characters, you must use quotes:

```ruby
an_object('my.host.name.com') {
  property_1: 10,
  property_2: 20,
}
```

The type can be anything you want, as long as it only includes characters, numbers, and underscores.

```ruby
a_rediculous_type_of_object('my.host.name.com') {
  property_1: 10,
  property_2: 20,
}
```
You can overwrite object properties.

```ruby
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

###Using objects

You can use these objects in regular assignments:

```ruby
value = an_object('my_object_name') 
# value will be:
# {'my_object_name' => 
#    {
#    'property_1' => 10, 
#    'property_2' => 20
#     }
#  }
```

And in arrays or hashes:

```ruby
values = [
  an_object(obj_1),
  an_object(obj_2),
]

hashes = [
  my_key: an_object('my_object_name'),
]

```

If you want to merge a set of object hashes, use:

```ruby
big_hash = {
  an_object('object_1'),
  an_object('object_2'),
  an_object('object_3'),
  an_object('object_4'),
}
```

###Selectors

All these big data structures are easy to define, but sometimes you want just 1 entry in the Array or one piece of the Hash. Selectors help you do this.

Selectors can be specified using array syntax

```ruby
an_array       = [1,2,3,4,5]
just_one_entry = an_array[2] # = 3
```

You can also use the method syntax:

```ruby
an_array    = [1,2,3,4,5]
first_entry = an_array.first # = 1
last_entry  = an_array.last # = 1
```

Selectors are passed to the underlying ruby system. So you can use any method the host language supports on the specified type. The connect syntax allows you to write selectors like this:

```ruby
array  = [1,2,3,4,5]
string = array.join(',')   # "1,2,3,4,5" 
hostname = 'DMACHINE1'     # Development machine 1
type     = hostname[0,1]   # type is 'O'
```

You can also use selectors when interpolating strings. 

```ruby
presidents = ['Clinton', 'Bush', 'Obama']
last_president = "The last President of the USA was #{presidents.last}"
```

Because interpolation only works on Connect variables, using selectors is  limited to interpolating Connect variables. Thus,

```ruby
last_president = "The last President of the USA was %{presidents.last}"
```

Doesn't work. Even if the array ` presidents` is defined in Puppet.

### Special selectors

The standard Array, Hash and String functions in ruby are already quite powerful. But sometimes you need some extra help. Connect defines the following special helper selectors.

#### extract

The `extract`  helper allows you to extract an array of values from an array of objects. An example clarifies this:
 
```ruby
all_nodes = [
  host('node1.domein.com'){
    ip : '10.0.0.1'
  },
  host('node2.domein.com'){
    ip : '10.0.0.2'
  }
  host('node3.domein.com'){
    ip : '10.0.0.3'
  }
]
ip_adresses = all_nodes.extract('ip')  # will be ['10.0.0.1','10.0.0.2','10.0.0.3']
```

#### to_resource

Sometimes your object contains values, the original puppet type doesn't support. To filter out all nonsupported attributes, you can use the `to_resource`  selector on an object. The selector must called with the type as a parameter.

```ruby
my_raw_host = host('db.domain.com') {
  ip: '10.0.0.100',
  just_a_random_attribute: 10,
}  # my_raw_host cannot be use for create_resource call's because if the invalid attribute

my_host = my_raw_host.to_resource('host') # can be used as a parameter for create_resource
```

###importing data

There ara a lot more possible sources of data for Puppet runs. For example:
- [PuppetDb](https://docs.puppetlabs.com/puppetdb/)
- LDAP server
- [racktables](http://racktables.org/)

Connect allows you to import data from any other data source. The generic syntax is:

```ruby
import from datasource(param1, param2) into scope:: {
  value1 = 'lookup 1'
  value2 = 'lookup 2'
}
```

Check [the list of available datasources](datasources.md) to see if the datasource you need, exists. Check [how to make your own datasource](building-a-datasource.md) if you need to access other data. 


```ruby
import from puppetdb into datacenter:: {
  ntp_servers = 'Class[Ntp::Server]'  # Fetches all NTP nodes from puppetdb 
                                      # into the array datacenter::ntp_servers

  dns_servers = 'Class[Dns::Server]'  # Fetches all DNS nodes from puppetdb 
                                      # into the array datacenter::dns_servers
}
```

Check [the puppetdb api](https://github.com/dalen/puppet-puppetdbquery/blob/master/README.md) for a specification of the supported query language.

Like other blocks, you can also use `begin` and `end`. If you do not specify a scope, the variables will go ito the default scope:

```ruby
import from puppetdb begin
  ntp_servers = 'Class[Ntp::Server]'
  dns_servers = 'Class[Dns::Server]'
end
```


Alternatively, using the ` yaml`  importer: 

```ruby
import from yaml('/aaa/a.yaml') do
  variable1 = 'key1'
  variable2 = 'yaml::key2'
end
```

**WARNING** Not all datasources are available yet. This is only to show the syntax.

## Ordering

All values and connections will be calculated **when all parsing is done**.  So for defining values, it doesn't make a difference if you reference a variable before it is defined. For example:

```ruby

first_value       = second_value
second_value = 10
```
 is the same as:

```ruby
second_value = 10
first_value       = second_value
```
for both values.

For interpolation, **there is a difference in order.** The interpolation takes the current value. For example:

```ruby
a_value  = 10
a_string = "The value is ${a_value}  # The value is 10
a_value = 20 # When you use the value a_valie in Puppet, it is 20
```

You can be caught of guard when using interpolation in the include statement. Included files are parsed once and only the first time when they are found. So:

```ruby
include 'an_include_file                      # defining value to 10
first_string = "the value is ${value}"   # results in "the value is 10
value = 20
second_string = "the value is ${value}"   # results in "the value is 20
include 'an_include_file                      # defining value to 10
third_string = "the value is ${value}"   # results in "the value is still 20
```



