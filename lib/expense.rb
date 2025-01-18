class Expense
  @@expenses = []

  def self.list
    @@expenses  
  end

  attr_reader :name, :id

  def initialize(name, price, category)
    @name, @price, @category = name, price, category
    @id = generate_id
    @@expenses << self
  end

  private

  def generate_id
    # per user expense IDs?
    return 0 if @@expenses.empty?

    @@expenses.map(:id).max + 1
  end
end