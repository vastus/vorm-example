ENV['RACK_ENV'] ||= 'development'

require_relative '../models/user'
require_relative '../models/category'
require_relative '../models/topic'
require_relative '../models/reply'

User.destroy_all
testos = User.create(username: 'testos', email: 'testos@teroni.fi', role: 'user', password: 'secretos', password_confirmation: 'secretos')
juhoh = User.create(username: 'juhoh', email: 'juhoh@lawdy.fi', role: 'admin', password: 'juhoh', password_confirmation: 'juhoh')
admin = User.create(username: 'admin', email: 'admin@lawdy.fi', role: 'admin', password: 'admin', password_confirmation: 'admin')
user = User.create(username: 'user', email: 'user@lawdy.fi', role: 'user', password: 'user', password_confirmation: 'user')

Category.destroy_all
gen = Category.create(name: 'General', description: 'General discussions. Can be (almost) anything.')
prog = Category.create(name: 'Programming', description: 'Datatypes, algorithms, languages, and everything else.')
street = Category.create(name: 'Cholo', description: 'Street man is the man. Hobos, hobas and such.')

Topic.destroy_all
pres = Topic.create(title: 'Present yourself', body: 'Everybody say my name!', category_id: gen.id, user_id: juhoh.id)

Reply.destroy_all
Reply.create(message: 'Howdy there neighbor, this is Frank.', topic_id: pres.id, user_id: testos.id)

