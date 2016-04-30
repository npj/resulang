# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resulang/version'

Gem::Specification.new do |spec|
  spec.name          = "resulang"
  spec.version       = Resulang::VERSION
  spec.authors       = ["Peter Brindisi"]
  spec.email         = ["peter.brindisi+resulang@gmail.com"]
  spec.summary       = %q{Resulang is a simple DSL to help create html resumes.}
  spec.homepage      = "https://github.com/npj/resulang"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor",               "~> 0.19.1"
  spec.add_dependency "activesupport",      "~> 4.2.6"
  spec.add_dependency "rack",               "~> 1.6.4"
  spec.add_dependency "mime-types",         "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rspec",   "~> 3.4.0"
end
