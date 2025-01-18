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

  def test_dashboard
    
  end

  def test_good_expense_creation
    post '/expenses', name: "Gym", price: "15.00", category: "Self-Improvement"

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

  ########################
  #        Helpers       #
  ########################
  def session
    last_request.env['rack.session']
  end
end