# frozen_string_literal: true

require_relative "lib/rspec/buildkite/analytics/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec-buildkite-analytics"
  spec.version       = RSpec::Buildkite::Analytics::VERSION
  spec.authors       = ["Buildkite"]
  spec.email         = ["hello@buildkite.com"]

  spec.summary       = "Track execution of specs and report to Buildkite Analytics"
  spec.homepage      = "https://buildkite.com"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/buildkite/rspec-buildkite-analytics"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport"
  spec.add_dependency "rspec-core"
  spec.add_dependency "rspec-expectations"
  spec.add_dependency "websocket"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end