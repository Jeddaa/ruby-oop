# require_relative 'app'
# require_relative 'start_page'

# def main
#   app = App.new
#   app.get_data

#   start_page = start_page.new(app)
# end

# main

require_relative 'app'
require_relative 'start_page'

app = App.new
homepage = HomePage.new(app)

homepage.start
