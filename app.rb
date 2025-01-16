require 'sinatra'

require 'sinatra/reloader' if development?
require 'pry' if development?

configure do
  #set :erb, :escape_html => :true
end
########################
#  Application Routes  #
########################


# # # # # # # # 
#  Expenses   #
# # # # # # # # 
# Dashboard
get '/' do
  @expenses = ['Purchase 1', 'Purchase 2']
  erb :dashboard
end

# Create new expense
get '/expenses/new' do
  erb :new_expense
end