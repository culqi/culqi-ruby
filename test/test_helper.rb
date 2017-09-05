require 'minitest/autorun'
require 'culqi-ruby'

Culqi.public_key = ENV['PUBLIC_KEY']
Culqi.secret_key = ENV['SECRET_KEY']
