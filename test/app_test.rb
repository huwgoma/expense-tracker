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
    
  end

  def teardown
    
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
    get '/expenses/0', {}, add_expenses_to_session
    
    assert_includes(last_response.body, "<h3>Expense Name: Beef</h3>")

    get '/expenses/1'
    assert_includes(last_response.body, "<h3>Expense Name: Gym</h3>")
  end

  # Update
  def test_edit_expense_form
    get '/expenses/0/edit', {}, add_expenses_to_session
    assert_includes(last_response.body, %q{<h2>Editing "Beef":</h2>})
  end

  def test_good_expense_edit
    post '/expenses/0/edit', 
      { name: 'Ribeye', price: '12', category: 'Food' },
      add_expenses_to_session

    assert_equal('Expense successfully updated.', session[:success])
    
    get last_response['Location']
    assert_includes(last_response.body, '<h3>Expense Name: Ribeye</h3>')
  end

  def test_bad_expense_edit
    post '/expenses/0/edit', 
      { name: '', price: '10', category: 'Food' },
      add_expenses_to_session
    
    assert_includes(last_response.body, 'Name must be between 1-100 characters.')
  end

  # Delete
  def test_expense_delete
    #post '/expenses/0/delete'
  end

  ########################
  #        Helpers       #
  ########################
  def session
    last_request.env['rack.session']
  end

  # Populate session[:expenses] with pre-defined dummy expenses
  def add_expenses_to_session
    { 'rack.session' => { 
      expenses: [
        create_expense('Beef', '10', 'Food', 0),
        create_expense('Gym', '60', 'Misc.', 1),
        create_expense('Lamb', '15', 'Food', 2)
      ]
    }}
  end

  def create_expense(name, price, category, id)
    Expense.new(name, price, category, id)
  end
end