Dir[File.join(File.dirname(__FILE__), './pages/*.rb')].each { |file| require file }

require_relative 'resources/document/GenerateDocument'
require_relative 'resources/Database'

require 'rubygems' if RUBY_VERSION < '1.9'

require 'sinatra'
require 'redis'
require 'json'
require 'date'
require "prawn"
