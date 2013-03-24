# encoding: utf-8

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'p0cket3/version'

Gem::Specification.new do |spec|

  spec.name = 'p0cket3'

  spec.version = P0cket3::VERSION
  spec.date = P0cket3::DATE

  spec.author = ["Éric Daspet"]
  spec.email = ['eric.daspet+p0cket3@survol.fr']

  spec.homepage = 'https://github.com/edas/p0cket3'
  spec.summary = "Pocket API v3 (unofficial)"
  spec.description = spec.summary + "."

  spec.license = 'LGPL'

  spec.platform    = Gem::Platform::RUBY
  spec.required_ruby_version = '~> 1.9.3'

  spec.add_dependency 'faraday', '~> 0.8.6'
  spec.add_dependency 'faraday_middleware', '~> 0.9.0'
  spec.add_dependency "activesupport", "~> 3.2.13"

  spec.files = %w(LICENSE.md README.md p0cket3.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")

  spec.require_path = 'lib'


  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency "rspec", "~> 2.13.0"

  spec.test_files = Dir.glob("{spec,test}/**/*.rb")

end
