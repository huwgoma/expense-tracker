ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
require 'rack/test'

require_relative '../app'

class ExpenseTrackerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def teardown
    Expense.list.clear
  end

  def test_dashboard
    
  end

  # Create
  def test_good_expense_creation
    post '/expenses', name: "Chipotle", price: "15.00", category: "Food"

    assert_equal('Expense successfully created.', session[:success])
  end

  def test_bad_expense_name
    post '/expenses', name: ""
    assert_includes(last_response.body, 'Name must be between 1-100 characters.')
  end

  def test_bad_expense_price
    post '/expenses', name: "Gym", price: "" # Empty
    assert_includes(last_response.body, 'Price must be a valid 2-decimal number.')
    
    post '/expenses', name: "Gym", price: "abc" # Non-Numeric
    assert_includes(last_response.body, 'Price must be a valid 2-decimal number.')

    post '/expenses', name: "Gym", price: "12." # Bad Format
    assert_includes(last_response.body, 'Price must be a valid 2-decimal number.')

    post '/expenses', name: "Gym", price: "-12" # Negative
    assert_includes(last_response.body, 'Price cannot be negative.')
  end

  # Read
  def test_view_expense
    create_expense("Chipotle", "12.00", "Food")
    

    get '/expenses/0'
    assert_includes(last_response.body, "<h3>Expense Name: Chipotle</h3>")
  end

  ########################
  #        Helpers       #
  ########################
  def session
    last_request.env['rack.session']
  end

  def create_expense(name, price, category)
    Expense.new(name, price, category)
  end


end