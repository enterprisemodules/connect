[![Build Status](https://travis-ci.org/hajee/connect.png?branch=master)](https://travis-ci.org/hajee/connect) [![Coverage Status](https://coveralls.io/repos/hajee/connect/badge.svg)](https://coveralls.io/r/hajee/connect)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What Connect does and why it is useful](#module-description)
3. [Setup - The basics of getting started with connect](#setup)
    * [What connect affects](#what-connect-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with connect](#beginning-with-connect)
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

##Module Description

Connect is a `hiera` backend. Using the Connect language, you can describe your Puppet parameters in an simple and concise way. You can:
- separate your config files into separate files and include them when you need them.
- You can easily reference variables. These variables can be in any other configuration file. They can be in an included configuration, or they can be defined at another hiera hierarchy level.

##Example

```
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

##detailed description

Check [the Connect Language, in a Nutshell](https://github.com/hajee/connect/blob/master/doc/nutshell.md), for more intro into the language.

##Troubleshooting

If you make mistakes in the config files, Connect will show you a parse error. The parse error shows the file and the  line number of the parse error. This should help you pinpoint any errors. The parsing of the connect files will be done once before the real puppet run starts. This ensures's Puppet can only start after it hs made certain the Connect configs are syntactically correct

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
