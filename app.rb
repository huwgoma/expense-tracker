require 'sinatra'

require 'sinatra/reloader' if development?
require 'pry' if development?


get '/' do
  'Hello'
end