Dir[File.join(File.dirname(__FILE__), './pages/*.rb')].each { |file| require file }

require_relative 'lib/Request'
require_relative 'resources/check/ValidFields'

require 'rubygems' if RUBY_VERSION < '1.9'

require 'sinatra'
require 'redis'
require 'json'
