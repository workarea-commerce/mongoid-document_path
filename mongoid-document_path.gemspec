# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/document_path/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-document_path"
  spec.version       = Mongoid::DocumentPath::VERSION
  spec.authors       = ["Ben Crouse"]
  spec.email         = ["bencrouse@gmail.com"]

  spec.summary       = %q{Tracks document paths to allow finding embedded documents.}
  spec.homepage      = "https://github.com/weblinc/mongoid-document_path.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
