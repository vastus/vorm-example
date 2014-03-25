require 'bcrypt'

require_relative '../lib/model'

class User < ORM::Model
  @@db = Mysql2::Client.new(host: 'localhost', username: 'testos', password: 'secretos', database: 'vorm')

  # Table name.
  table :users

  # Fields for model.
  fields :email, :username, :password_hash, :password_salt

  # Virtual attrs
  attr_accessor :password, :password_confirmation

  # Validations
  validates :email, -> (email) do
    if email.nil? || email.strip.empty?
      "cannot be empty"
    end
  end

  validates :username, -> (username) do
    if username.nil? || username.strip.empty?
      "cannot be empty"
    end
  end

  validates :username, -> (username) do
    if username.nil? || username.length < 3
      "too short"
    end
  end
end

