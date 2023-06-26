require_relative 'person'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'
require_relative 'book'
require_relative 'rental'
require 'pry'
require 'json'

class App
  attr_reader :books, :people, :rentals, :classroom

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
  def get_data()
    books = JSON.parse(fetch_data('books'))
    people = JSON.parse(fetch_data('people'))
    rentals = JSON.parse(fetch_data('rentals'))

    books.each do |book|
      @books << Book.new(book['title'], book['author'])
    end

    people.each do |person|
      @people << if person['type'] == 'Teacher'
                   Teacher.new(person['age'], person['name'], person['specialization'], parent_permission: true)
                 else
                   Student.new(nil, person['age'], person['name'], parent_permission: person['parent_permission'])
                 end
    end

    rentals.each do |rental|
      @rentals << Rental.new(rental)
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
        puts "[Student]: ID: #{person.id}, Name: #{person.name}, age: #{person.age}"
      else
        puts "[Teacher]: ID: #{person.id}, Name: #{person.name}, age: #{person.age}"
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
      puts 'select book by number'
      @books.each_with_index do |book, index|
        puts "#{index} - Title: #{book.title}, Author: #{book.author}"
      end

      book_index = gets.chomp.to_i

      puts 'select person by number'
      @people.each_with_index do |person, index|
        puts "#{index} - #{person.class}, Name: #{person.name}"
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
      puts 'all id'
      @rentals.each do |rental|
        puts " #{rental.person.id}, Name: #{rental.person.name}"
      end
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
  end

  def show_menu
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

  def on_exit
    # puts 'Thank you for using the Library'
    updated_books = []

    @books.each do |book|
      updated_books << { 'title' => book.title, 'author' => book.author }
    end

    File.write('files/books.json', JSON.pretty_generate(updated_books))

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
    updated_rentals = []
    @rentals.each do |rental|
      updated_rentals << { 'title' => rental.book.title, 'author' => rental.book.author, 'date' => rental.date }
    end
    File.write('files/rentals.json', JSON.pretty_generate(updated_rentals))
    exit
  end
end
