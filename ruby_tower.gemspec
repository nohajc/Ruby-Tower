# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_tower/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_tower"
  spec.version       = RubyTower::VERSION
  spec.authors       = ["Jan Noha"]
  spec.email         = ["nohajc@gmail.com"]

  spec.summary       = %q{Icy Tower clone written in Ruby}
  spec.homepage      = "https://github.com/nohajc/Ruby-Tower"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables   = "ruby_tower"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "gosu", "~> 0.10.5"
  spec.add_runtime_dependency "chipmunk", "~> 6.1"
end
