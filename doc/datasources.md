# Available datasources

The Connect language contains a number of datasources that are distributed with the core language:
- Yaml
- Decrypt
- Puppedb (**not yet**)

##The Yaml datasource

TODO


##The decrypt datasource

The decrypt datasource is a useful datasource to store secret stuff in your Connect configuration. Here is an example:

```

import from encryped("${password}") into passwords:: do
  ftp_password        = 4tXI3V4yU3+E0b8MB4Td2A==|RGh76OTpA0wQ9pK1bCuCkA==
  satellite_password  = OUMkw35FgJs5eK51BvBvAw==|ixoQf091i/wGKEWjZJAd9g==
  download_password   = Pv/AZPVyUTVAXZzwTDBlvg==|wLb96I7c6iBN2nIcp62zPA==
  secret_stuff        = j2S3BHEeRqLnCJV8MaVQ3A==|r1UcBZgiatyMh62CWxjCRg==
end
```
this allows you to store your secret stuff into Connect files. At Puppet deployment time you can let Connect decrypt them.

##PuppedDB datasource

