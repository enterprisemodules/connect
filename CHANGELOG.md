History
========

25-5-2016  version 0.0.23
-------------------------
- Fix errors when config file contains only comments
- Fix reporting of line numbers when using multi line assignments

20-5-2016  version 0.0.22
-------------------------
- Better debugging messages on assign
- Fixed some issue's with ruby incompatibility

30-10-2015  version 0.0.21
-------------------------
- Fixes to run on Puppet Enterprise 2015.2
- No more GEM distributions

30-10-2015  version 0.0.20
-------------------------
- Refresh lookups if search order changes

29-10-2015  version 0.0.19
-------------------------
- Refresh lookups if a config file has changed

25-10-2015  version 0.0.18
-------------------------
- Still support ruby 1.8.7

25-10-2015  version 0.0.17
-------------------------
- Added support for Hiera 2.0

25-10-2015  version 0.0.16
-------------------------
- Added support for building a GEM

24-10-2015  version 0.0.15
-------------------------
- Added support for jruby

23-07-2015  version 0.0.14
-------------------------
- Fixed some bugs in selectors on objects

11-06-2015  version 0.0.14
-------------------------
- Added slice-content selector

10-06-2015  version 0.0.13
-------------------------
- Added Object and Hash convenience function slice.

10-06-2015  version 0.0.12
-------------------------
- Fixed a bug when using a object reference in a hash inside an array

13-05-2015  version 0.0.11
-------------------------
- Added support for multiple named iterators

9-05-2015  version 0.0.10
-------------------------
- Implemented the object iterator
- Added the description of the object inspector to the readme

3-05-2015  version 0.0.9
------------------------
- Extracted the datasources
- Fix error messages when using connect without a valid section in hiera.yaml
- Add support for data source names with underscores.

23-04-2015  version 0.0.8
--------------------------
- Add support for range syntax in selectors
- Add support for negative numbers and explicit positive numbers
- Add support for wildcard object searches

05-04-2015  version 0.0.7
--------------------------
- Added Puppet connect objects face to list objects
- object('name') is now different dfrom object(name). Without quotes is a reference
- awesome_print is no longer a requirement, but an add-on


03-04-2015  version 0.0.6
--------------------------
- Fixed a bug on interpreting Objects beyond the first level
- Unquoted object names are references


02-04-2015  version 0.0.5
--------------------------
- Fixed a bug on interpreting Hashes beyond the first level


02-04-2015  version 0.0.4
--------------------------
- Added cross referencing output to Puppetconnect values. 


29-03-2015  version 0.0.3
--------------------------
- Added Puppet connect values commands to read the configs


24-03-2015  version 0.0.2
--------------------------
- Better support for selectors
- extended the language documentation
- better error messages when using selectors
- better error messages when using invalid attributes on objects
- allow selectors as integral part of the language. Now any value or reference can have a selector

11-03-2015  version 0.0.1
--------------------------
- Initial release
