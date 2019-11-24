# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'gitmqueue'
  spec.version       = GitMQueue::VERSION
  spec.authors       = ['Emad Elsaid']
  spec.email         = ['emad.elsaid.hamed@gmail.com']

  spec.summary       = 'Git Message Queue'
  spec.description   = <<-DESC
  An interface to use Git repositories as a message queue to communicate between services'
  DESC
  spec.homepage      = 'https://www.github.com/emad-elsaid/gitmqueue'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rugged', '~> 0.28'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
