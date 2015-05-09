[![Build Status](https://travis-ci.org/hajee/connect.png?branch=master)](https://travis-ci.org/hajee/connect) [![Coverage Status](https://coveralls.io/repos/hajee/connect/badge.svg)](https://coveralls.io/r/hajee/connect)[![Code Climate](https://codeclimate.com/github/hajee/connect/badges/gpa.svg)](https://codeclimate.com/github/hajee/connect)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What Connect does and why it is useful](#module-description)
3. [Setup - The basics of getting started with connect](#setup)
    * [What connect affects](#what-connect-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with connect](#beginning-with-connect)
    * [Tools](#tools)
      * [The value inspector](#the-values-inspector)
      * [The objects inspector](#the-objects-inspector)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Troubleshooting](#troubleshooting)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
    * [OS support](#os-support)
    * [Tests - Testing your configuration](#testing)

##Overview

Connect is a replacement for YAML in hiera. When you start with Puppet, using hiera with YAML is an excellent way to split code and configuration data. But when your configuration grows, you start to notice some troubles with this combination:
- Your YAML files start to become bigger and bigger and bigger and slowly but surely become incomprehensible.
- You would like to reference other values. YAML supports this..... but not between different files. Besides the `&` and `*` anchor syntax becomes a hassle, when you use it much.
- You have found the yaml interpolation using `"%{hiera('lookup_value')"` to lookup values over you whole YAML structure..... but noticed, you can only use this for strings, and not for other data types.

If you recognize any of these problems, Connect might be for you! If you haven't run into these problems, Connect is probably like taking a sledgehammer to crack a nut, and it is best to stay with YAML.

Want to know the details, Check [the Connect Language, in a Nutshell](https://github.com/hajee/connect/blob/master/doc/nutshell.md), for more intro into the language.

##Module Description

Connect is a `hiera` backend. Using the Connect language, you can describe your Puppet parameters in an simple and concise way. You can:
- separate your config files into separate files and include them when you need them.
- You can easily reference variables. These variables can be in any other configuration file. They can be in an included configuration, or they can be defined at another hiera hierarchy level.
- You can import data from other sources like [PuppetDb](https://docs.puppetlabs.com/puppetdb/) and mix and match them with your own parameter settings.
- You can reference encrypted variables in a safe way.

...and much more.

##Example

```ruby
domain_name = 'example.com'
import from puppetdb into datacenter:: {
  ntp_servers = 'Class[Ntp::Server]'  # Fetches all NTP nodes from puppetdb 
                                      # into the array datacenter::ntp_servers

  dns_servers = 'Class[Dns::Server]'  # Fetches all DNS nodes from puppetdb 
                                      # into the array datacenter::dns_servers
}
ftp_node    = "ftp.${domain_name}"
all_nodes   = [
  ntp_servers,
  dns_servers,
  ftp_node,
]

include 'generic_settings/*'        # include all settings
include "${domain_name}/settings"   # include specific setting for domain
```

Check [the Connect Language, in a Nutshell](https://github.com/hajee/connect/blob/master/doc/nutshell.md), for more intro into the language.

##Setup

###Installing the module

To use the connect hiera module, you first have to make sure it is installed.

```sh
puppet module install hajee/connect
```

If you are using a Puppetfile, you need the following lines:

```
mod 'hajee-connect'
```

###Enabling Connect in hiera

To start using the connect hiera backend, you have to enable it in the hiera config file. Add the `connect` line to the `:backends:` array. The order of the entries in the array, is the order hiera will use to resolve the lookups. 

```yaml
---
:backends:
  - yaml
  - connect

...

:connect:
  :datadir: /etc/puppet/config

...
```

Add a `:datadir:` entry for the connect backend. The default is `/etc/puppet/config`.

###What connect affects

If you have configured connect, like specified in the `hiera.yaml` **ALL** hiera lookups will be passed to the Connect backend. 

###Setup Requirements

Because connect is based on hiera and puppet, you need to have both the hiera and puppet gem installed.

Some of the [data sources](https://github.com/hajee/connect/blob/master/datasources.md) require extra Ruby gems or other components. Check their documentation for details

###Beginning with connect module

To test if everything works, ue the next steps:
- add connect to the `hiera.yaml`. You can find an example [here](https://github.com/hajee/connect/blob/master/setup/hiera.yaml)
- Create a `common.config` in the folder `/etc/puppet/config`. You can find [an example here](https://github.com/hajee/connect/blob/master/setup/common.config).
- Create a `test.pp` with [this content](https://github.com/hajee/connect/blob/master/tests/test.pp)
- Run the small test manifest and check the output
```
$ puppet apply test.pp
Notice: Scope(Class[Test]): it works
Notice: Compiled catalog for 10.0.2.15 in environment production in 0.20 seconds
Notice: Finished catalog run in 0.03 seconds
```

You can also use the values inpsector to check the value:

```sh
$ puppet connect values test::parameter
```

###Tools

#### The values inspector

Bundled with connect comes the values inspector. This tool lets you see the interpreted value of a specified parameter. In lay man's terms, it parses your connect file's and shows you the value.

```
$ puppet connect values my_parameter
```

You can also use a wildcard for the parameter. Wildcards are specified as [regular expressions](http://www.regular-expressions.info/reference.html).

```
$ puppet connect values my_scope::.*
```

This will show all parameters in the scope `my_scope`.

`puppet connect values`  will also show you where your parameters are defined and referenced. This is a tremendous help when debugging or just understand a complex set of connect configuration files.


#### The objects inspector

Similar to the values inspector, is the objects inspector This tool lets you see the interpreted value of a specified object. Just like the values inspector, it parses your connect file's and shows you the contents of your objects.

```
$ puppet connect objects  my_node
```

You can also use a wildcard for the parameter. Wildcards are specified as [regular expressions](http://www.regular-expressions.info/reference.html).

```
$ puppet connect objects my_*.
```

This will show all objects starting with  `my_`.

If you just want to see the objects of a certain type, use `--type`  or `-t`

```
$ puppet connect objects --type host my_*.
```

Will show you all just starting with `my_`

`puppet connect objects`  will also show you where your objects are defined and referenced. This is a tremendous help when debugging or just understand a complex set of connect configuration files.


###Using the accompanying Vagrant box

You can also get started with a Vagrant box that is preconfigured.

```
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'hajee/centos-5.10-x86_64'...
==> default: Matching MAC address for NAT networking...
...
    default: Running: inline script
==> default: Running provisioner: shell...
    default: Running: inline script
==> default: Running provisioner: shell...
    default: Running: inline script
$ vagrant ssh
Last login: Sun Dec 14 17:08:18 2014 from 10.0.2.2
$ sudo su -               # Make yourself root
$ cd /vagrant/tests/      # Goto the folder containing the test manifest
$ puppet apply test.pp    # Apply it.
Notice: Scope(Class[Test]): it works localhost
Notice: Compiled catalog for localhost.localdomain in environment production in 0.39 seconds
Notice: Finished catalog run in 0.03 seconds
$ 
```
On your host os, you can edit the `examples/default.config' file to experiment with the Connect language.

##detailed description

Check [the Connect Language, in a Nutshell](https://github.com/hajee/connect/blob/master/doc/nutshell.md), for more intro into the language.

##Troubleshooting

If you make mistakes in the config files, Connect will show you a parse error. The parse error shows the file and the  line number of the parse error. This should help you pinpoint any errors. The parsing of the connect files will be done once before the real puppet run starts. This ensures's Puppet can only start after it has made certain the Connect configs are syntactically correct

##Limitations

This module is tested CentOS and Redhat. It will probably work on other Linux distributions. 

##Development

This is an open source project, and contributions are welcome.

###OS support

Currently we have tested:

* CentOS 5
* Redhat 5


###Testing

Make sure you have:

* rake
* bundler

Install the necessary gems:

    bundle install

And run the tests from the root of the source code:

    rake spec

We are currently working on getting the acceptance test running as well.
