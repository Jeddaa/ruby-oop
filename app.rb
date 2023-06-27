require_relative 'person'
require_relative 'student'
require_relative 'teacher'
require_relative 'book'
require_relative 'rental'
require 'json'

class App
  attr_accessor :books, :people, :rentals

  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  # method to fetch data from json file
  def fetch_data(file_name)
    if File.exist?("files/#{file_name}.json")
      File.read("files/#{file_name}.json")
    else
      empty_json = [].to_json
      File.write("files/#{file_name}.json", empty_json)
      empty_json
    end
  end

  # method to get data from json file
  def load_data
    books = JSON.parse(fetch_data('books'))
    people = JSON.parse(fetch_data('people'))
    rentals = JSON.parse(fetch_data('rentals'))

    books.each do |book|
      @books << Book.new(book['title'], book['author'])
    end

    people.each do |person|
      @people << if person['type'] == 'Teacher'
                   Teacher.new(person['age'], person['specialization'], person['name'], parent_permission: true)
                 else
                   Student.new(1, person['age'], person['parent_permission'], person['name'])
                 end
    end

    rentals.each do |rental|
      renter = @people.select { |person| person.name == rental['person_name'] }
      rented_book = @books.select { |book| book.title == rental['book_titles'] }
      @rentals << Rental.new(rental['date'], rented_book[0], renter[0])
    end
  end

  # Method to list all books
  def list_all_books
    puts 'All Books:'
    @books.each do |book|
      puts "Title: #{book.title}, Author: #{book.author}"
    end
  end

  # Method to list all people
  def list_all_people
    @people.each do |person|
      if person.instance_of?(Student)
        puts "[Student]: ID: #{person.id}, Name: #{person.name},
        age: #{person.age} parent permission: #{person.parent_permission}"
      else
        puts "[Teacher]: ID: #{person.id}, Name: #{person.name},
        age: #{person.age} specialization: #{person.specialization}"
      end
    end
  end

  # Method to create a person
  def create_person
    puts 'press 1 for student 2 for teacher'
    is_student = gets.chomp.to_i
    puts 'Enter name:'
    name = gets.chomp
    puts 'Enter age:'
    age = gets.chomp.to_i

    case is_student
    when 1
      print 'Does student have parent permission [Y/N]: '
      parent_permission = gets.chomp.downcase == 'y'
      student = Student.new(1, age, parent_permission, name)
      @people.push(student)

    when 2
      print 'What is the teachers specialization: '
      specialization = gets.chomp
      teacher = Teacher.new(age, specialization, name)
      @people.push(teacher)
      puts 'Person created successfully.'
    end
  end

  # Method to create a book
  def create_book
    puts 'Enter book title:'
    title = gets.chomp
    puts 'Enter book author:'
    author = gets.chomp

    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully.'
  end

  # Method to create a rental
  def create_rental
    if @books.empty? || @people.empty?
      puts 'No people or books created please create a person/books'
      return
    end

    puts 'select book by number'
    @books.each_with_index { |book, index| puts "#{index}) Title: #{book.title}, Author: #{book.author}" }

    book_index = gets.chomp.to_i
    puts 'select person by number'
    @people.each_with_index do |person, index|
      puts "#{index}) Name: #{person.name} Age: #{person.age} Id: #{person.id}"
    end
    person_index = gets.chomp.to_i
    puts 'Enter date:'
    date = gets.chomp
    rental = Rental.new(date, @books[book_index], @people[person_index])
    @rentals << rental
    puts 'Rental created successfully.'
  end

  # Method to list rentals
  def list_rentals
    puts 'select id'
    id = gets.chomp.to_i

    puts 'All Rentals for this id:'
    @rentals.each do |rental|
      if rental.person.id == id
        puts "Title: #{rental.book.title}, Author: #{rental.book.author}, Date: #{rental.date}"
      else
        puts 'rental not found'
      end
    end
  end

  def options
    puts ''
    puts 'Please choose an option by entering a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'
  end

  def update_people
    updated_people = []

    @people.each do |person|
      if person.instance_of?(Teacher)
        updated_people << { 'type' => 'Teacher', 'id' => person.id, 'name' => person.name, 'age' => person.age,
                            'specialization' => person.specialization }
      elsif person.instance_of?(Student)
        updated_people << { 'type' => 'Student', 'id' => person.id, 'name' => person.name, 'age' => person.age,
                            'parent_permission' => person.parent_permission }
      end
    end
    File.write('files/people.json', JSON.pretty_generate(updated_people))
  end

  def on_exit
    puts 'Thank you for using the Library'
    updated_books = []

    @books.each do |book|
      updated_books << { 'title' => book.title, 'author' => book.author }
    end

    File.write('files/books.json', JSON.pretty_generate(updated_books))

    update_people
    updated_rentals = []

    @rentals.each do |rental|
      updated_rentals << { 'person_name' => rental.person.name, 'book_titles' => rental.book.title,
                           'date' => rental.date }
    end

    File.write('files/rentals.json', JSON.pretty_generate(updated_rentals))
    exit
  end
end
