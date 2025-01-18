require 'sinatra'

require 'sinatra/reloader'
require 'pry' if development?

require_relative 'lib/expense'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  #set :erb, :escape_html => :true
  
end
########################
#  Application Routes  #
########################
before do
  @categories = ['Food', 'Misc', 'Self-Improvement']
end

# # # # # # #
#  Expenses #
# # # # # # # 
# Dashboard
get '/' do
  @expenses = Expense.list

  erb :dashboard
end

# (Form) - Create new expense
get '/expenses/new' do
  erb :new_expense
end

# Create new expense
post '/expenses' do
  name, price, category = params[:name], params[:price], params[:category]

  session[:error] = expense_errors(name, price, category)
  if session[:error]
    erb :new_expense
  else
    Expense.new(name, price, category)
    session[:success] = "Expense successfully created."
    redirect '/'
  end
end

# View an expense
get '/expenses/:expense_id' do
  @expense = Expense.find(params[:expense_id].to_i)

  erb :expense
end


########################
#        Helpers       #
########################
def expense_errors(name, price, category)
  expense_name_error(name) ||
    expense_price_error(price) 
    # || expense_category_error(category)

end

def expense_name_error(name)
  'Name must be between 1-100 characters.' unless name.size.between?(1, 100)
end

def expense_price_error(price)
  begin
    'Price cannot be negative.' if sprintf('%.2f', price).to_f.negative?
  rescue ArgumentError
    'Price must be a valid 2-decimal number.'
  end
end
