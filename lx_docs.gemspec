
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lx_docs/version"

Gem::Specification.new do |spec|
  spec.name          = "lx_docs"
  spec.version       = LxDocs::VERSION
  spec.authors       = ["Alex Clink"]
  spec.email         = ["code@alexclink.com"]

  spec.summary       = %q{TODO: Write a short summary, because RubyGems requires one.}
  spec.summary       = "Generate docs for your rails api"
  spec.description   = "Automatically gathers your routes into a machine readable json file and provides a DSL for docs"
  spec.homepage      = "https://pixelfaucet.com/software/rails_api_docs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
