require_relative 'nameable'

class Person < Nameable
  def initialize(age, parent_permission, name = 'unknown')
    super()
    @id = Random.rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  attr_accessor :name, :age
  attr_reader :id, :parent_permission, :rentals

  def of_age?
    return true if @age >= 18

    false
  end

  def can_use_services?
    @parent_permission || of_age?
  end

  def correct_name()
    @name
  end

  def add_rental(book, date)
    Rental.new(date, book, self)
  end
end
