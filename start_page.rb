def menu(app)
  app.show_menu
  print '>>> :'
  gets.chomp.to_i
end

def manage_selection(app, option)
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

  selection = tasks[option] || tasks[:default]
  app.send(selection)
end

def start_page(app)
  loop do
    option = menu(app)
    manage_selection(app, option)
    puts "\n"
  end
end
