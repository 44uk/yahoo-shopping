# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yahoo-shopping/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["yukku0423"]
  gem.email         = ["yukku0423@gmail.com"]
  gem.description   = %q{Yahoo! Japan Shopping Ruby API}
  gem.summary       = %q{Yahoo! Japan Shopping Ruby API}
  gem.homepage      = "http://44uk.net"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yahoo-shopping"
  gem.require_paths = ["lib"]
  gem.version       = Yahoo::Shopping::VERSION
end
