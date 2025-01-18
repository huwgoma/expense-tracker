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

  def test_good_expense_creation
    
  end

  def test_bad_expense_creation
    post '/expenses', name: ""
    assert_includes(last_response.body, 'Expense name must be between 1-100 characters.')
    # name => cannot be empty
    # price
  end
end