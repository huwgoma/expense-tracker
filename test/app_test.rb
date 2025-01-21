ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
require 'rack/test'

require 'pry'
require_relative '../app'


class ExpenseTrackerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @expense_id = 0
  end

  def teardown
    @expense_id = 0
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
    get '/expenses/0', {}, add_expense_to_session('Meat', '10', 'Food')
    
    assert_includes(last_response.body, "<h3>Expense Name: Meat</h3>")

    get '/expenses/1', {}, add_expense_to_session('Gym', '12', 'Misc.')
    assert_includes(last_response.body, "<h3>Expense Name: Gym</h3>")
  end

  # Update
  def test_edit_expense_form
    get '/expenses/0/edit', {}, add_expense_to_session('Meat', '10', 'Food')
    assert_includes(last_response.body, %q{<h2>Editing "Meat":</h2>})
  end

  def test_edit_expense
    
  end

  ########################
  #        Helpers       #
  ########################
  def session
    last_request.env['rack.session']
  end

  def create_expense(name, price, category)
    expense = Expense.new(name, price, category, @expense_id)
    @expense_id += 1
    expense
  end

  def add_expense_to_session(name, price, category)
    { 'rack.session' => { 
      expenses: [create_expense(name, price, category)] 
    } }
  end
end