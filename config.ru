require 'rubygems'
require 'sinatra'
require 'yaml'
require 'json'
require 'digest'
require 'digest/sha2'
require 'RMagick'

set :environment, ENV['RACK_ENV'].to_sym
disable :run, :reload

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/public/')
require './public/app.rb'

run Sinatra::Application

