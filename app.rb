require 'sinatra'

require 'sinatra/reloader' if development?
require 'pry' if development?

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  #set :erb, :escape_html => :true
  
end
########################
#  Application Routes  #
########################
before do
  @categories = ['Food', 'Misc']
end

# # # # # # # # 
#  Expenses   #
# # # # # # # # 
# Dashboard
get '/' do
  @expenses = ['Purchase 1', 'Purchase 2']
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
  end
  # validate params (name, price, category)
  # - if there are any errors, set them and re-render :new_expense
  # - if there are no errors, create a new Expense object and redirect to 
  #   dashboard(?)
  #binding.pry
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
