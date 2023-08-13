$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'culqi/version'

Gem::Specification.new do |s|
  s.name          = 'ruby-culqi'
  s.version       = Culqi::VERSION
  s.date          = '2223-07-13'
  s.summary       = "Culqi Ruby"
  s.description   = "Biblioteca de Culqi en Ruby API v2"
  s.authors       = ["Jordan Diaz Diaz"]
  s.email         = ['jordandiaz2016@gmail.com']
  s.files         = ["lib/culqi-ruby.rb"]
  s.homepage      = 'http://rubygems.org/gems/culqi'
  s.license       = 'MIT'
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.0.0'
end
