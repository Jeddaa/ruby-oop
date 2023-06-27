class HomePage
  def initialize(app)
    @app = app
  end

  def display_options
    @app.options
    print '>>> :'
    gets.chomp.to_i
  end

  def manage_selection(options)
    tasks = {
      1 => :list_all_books,
      2 => :list_all_people,
      3 => :create_person,
      4 => :create_book,
      5 => :create_rental,
      6 => :list_rentals,
      7 => :on_exit,
      default: :invalid_option
    }

    selection = tasks[options] || tasks[:default]
    @app.send(selection)

    exit if options == 7
  end

  def start
    loop do
      manage_selection(display_options)
      puts "\n"
    end
  end
end
