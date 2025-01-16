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
end