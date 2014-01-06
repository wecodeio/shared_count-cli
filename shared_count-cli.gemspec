# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shared_count/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "shared_count-cli"
  spec.version       = SharedCount::Cli::VERSION
  spec.authors       = ["Cristian Rasch"]
  spec.email         = ["cristianrasch@gmail.com"]
  spec.summary       = %q{CLI to the shared_count_api gem.}
  spec.homepage      = "https://github.com/wecodeio/shared_count-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "shared_count_api", "~> 0.2"
  spec.add_runtime_dependency "dotenv"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.2.0"
end
