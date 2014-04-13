ENV['RACK_ENV'] ||= 'development'

require_relative '../models/user'
require_relative '../models/category'
require_relative '../models/topic'

User.destroy_all
testos = User.create(username: 'testos', email: 'testos@teroni.fi', password: 'secretos', password_confirmation: 'secretos')
juhoh = User.create(username: 'juhoh', email: 'juhoh@lawdy.fi', password: 'juhoh', password_confirmation: 'juhoh')

Category.destroy_all
gen = Category.create(name: 'General', description: 'General discussions. Can be (almost) anything.')
prog = Category.create(name: 'Programming', description: 'Datatypes, algorithms, languages, and everything else.')
street = Category.create(name: 'Cholo', description: 'Street man is the man. Hobos, hobas and such.')

Topic.destroy_all
Topic.create(title: 'Present yourself', body: 'Everybody say my name!', category_id: gen.id)

