# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swipehq/version'

Gem::Specification.new do |gem|
  gem.name          = "swipehq"
  gem.version       = SwipeHQ::VERSION
  gem.authors       = ["Marcelo Wiermann"]
  gem.email         = ["marcelo.wiermann@gmail.com"]
  gem.description   = %q{SwipeHQ for Ruby}
  gem.summary       = %q{SwipeHQ for Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rest-client'
  gem.add_dependency 'json'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rb-fsevent'
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'

end
