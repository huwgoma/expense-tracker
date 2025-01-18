class Expense
  @@expenses = []

  def self.list
    @@expenses  
  end

  attr_reader :name

  def initialize(name, price, category)
    @name, @price, @category = name, price, category
    @@expenses << self
  end
end