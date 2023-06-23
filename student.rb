require_relative 'person'

class Student < Person
  attr_reader :classroom

  def initialize(classroom, age, parent_permission, name = 'unknown')
    super(age, parent_permission, name)
    @classroom = classroom
  end

  def play_hooky()
    '¯\(ツ)/¯'
  end
end
