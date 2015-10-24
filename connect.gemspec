# coding: utf-8
lib = File.expand_path('./lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'connect/version'

Gem::Specification.new do |spec|
  spec.name          = "connect"
  spec.version       = Connect::VERSION
  spec.authors       = ["Bert Hajee"]
  spec.email         = ["bert.hajee@enterprisemodules.com"]

  spec.summary       = %q{A replacement for YAML in hiera. Connect allows you to describe and transform your data for usage in Puppet modules}
  spec.description   = %q{A replacement for YAML in hiera. Connect allows you to describe and transform your data for usage in Puppet modules}
  spec.homepage      = "https://github.com/hajee/connect"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "racc", "~> 1.4.12"
end
