class Expense
  attr_reader :name, :price, :category, :id

  def initialize(name, price, category, id)
    @name, @category, @id = name, category, id
    @price = format_price(price)
  end

  def edit(name, price, category)
    self.name = name
    self.price = format_price(price)
    self.category = category
  end

  private

  attr_writer :name, :price, :category

  def format_price(price)
    sprintf('%.2f', price)
  end
end