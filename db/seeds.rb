ENV['RACK_ENV'] ||= 'development'

require_relative '../models/user'
require_relative '../models/category'

User.destroy_all
User.new(username: 'testos', email: 'testos@teroni.fi', password: 'secretos', password_confirmation: 'secretos').save
User.new(username: 'juhoh', email: 'juhoh@lawdy.fi', password: 'juhoh', password_confirmation: 'juhoh').save

Category.destroy_all
Category.new(name: 'General', description: 'General discussions. Can be (almost) anything.').save
Category.new(name: 'Programming', description: 'Datatypes, algorithms, languages, and everything else.').save

