require_relative 'app'
require_relative 'start_page'

app = App.new
app.load_data
homepage = HomePage.new(app)

homepage.start
