$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'culqi/version'

Gem::Specification.new do |s|
  s.name          = 'culqi-ruby'
  s.version       = Culqi::VERSION
  s.date          = '2017-04-08'
  s.summary       = "Culqi Ruby"
  s.description   = "Biblioteca de Culqi en Ruby API v2"
  s.authors       = ["Willy Aguirre"]
  s.email         = ['marti1125@gmail.com','willy.aguirre@culqi.com']
  s.files         = ["lib/culqi-ruby.rb"]
  s.homepage      = 'http://rubygems.org/gems/culqi-ruby'
  s.license       = 'MIT'
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.0.0'
end
