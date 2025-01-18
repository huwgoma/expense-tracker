class Expense
  @@expenses = []

  def self.list
    @@expenses  
  end

  def self.find(id)
    @@expenses.find { |expense| expense.id == id }
  end

  attr_reader :name, :price, :category, :id

  def initialize(name, price, category)
    @name, @category = name, category
    @price = format_price(price)
    @id = generate_id
    
    @@expenses << self
  end

  private

  def format_price(price)
    sprintf('%.2f', price)
  end

  def generate_id
    # per user expense IDs?
    return 0 if @@expenses.empty?

    @@expenses.map(&:id).max + 1
  end
end