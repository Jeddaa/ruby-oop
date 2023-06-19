require_relative 'student'

class Teacher < Student
  def initialize(classroom, specialization, age, name: 'unknown', parent_permission: true)
    super(name, age, parent_permission, classroom)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end
