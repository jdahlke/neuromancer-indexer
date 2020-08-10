# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neuromancer/indexer/version'

Gem::Specification.new do |spec|
  spec.name          = 'neuromancer-indexer'
  spec.version       = Neuromancer::Indexer::VERSION
  spec.authors       = ['Joergen Dahlke']
  spec.email         = ['joergen.dahlke@infopark.de']

  spec.summary       = 'Ruby gem to push data for indexing to the Neuromancer service.'
  spec.description   = 'Ruby gem to push data for indexing to the Neuromancer service.'
  spec.homepage      = 'https://github.com/jdahlke/neuromancer-indexer'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-sqs'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.86.0'
end
