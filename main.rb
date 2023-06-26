require_relative 'app'
require_relative 'start_page'

def main
  app = App.new
  app.get_data

  start_page(app)
end

main
