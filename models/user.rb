require 'bcrypt'

require_relative '../lib/model'

class User < ORM::Model
  @@db = Mysql2::Client.new(host: 'localhost', username: 'testos', password: 'secretos', database: ORM::Config.db(:database))

  # Table name.
  table :users

  # Fields for model.
  fields :email, :username, :password_hash, :password_salt

  # Virtual attrs
  attr_accessor :password, :password_confirmation

  # Validations
  validates :email, -> (user) do
    if user.email.nil? || user.email.strip.empty?
      "cannot be empty"
    end
  end

  validates :username, -> (user) do
    if user.username.nil? || user.username.strip.empty?
      "cannot be empty"
    end
  end

  validates :username, -> (user) do
    if user.username.nil? || user.username.length < 3
      "too short"
    end
  end

  validates :password, -> (user) do
    if user.password.nil? || user.password.strip.empty?
      "cannot be empty"
    end
  end

  validates :password_confirmation, -> (user) do
    if user.password_confirmation.nil? || user.password_confirmation.strip.empty?
      "cannot be empty"
    end
  end

  validates :password_confirmation, -> (user) do
    if user.password && user.password_confirmation &&
      !user.password.strip.empty? && !user.password_confirmation.strip.empty? &&
      user.password != user.password_confirmation
      "passwords don't match"
    end
  end

  validates :username, -> (user) do
    if user.username && !User.find_by(:username, user.username).nil?
      "taken"
    end
  end

  validates :email, -> (user) do
    if user.email && !User.find_by(:email, user.email).nil?
      "taken"
    end
  end

  def authenticate(plain)
    hashed = BCrypt::Engine::hash_secret(plain, password_salt)
    password_hash == hashed
  end

  def save
    return false if !valid?
    encrypt_password
    super()
  end

  def update(params)
    self.username = params[:username]
    self.email = params[:email]
    valid?
    if errors[:username].empty? && errors[:email].empty?
      return false
    end
    k = [:username, :email]
    v = k.map(&method(:send))
    s = (k.zip(v)).map{|p| "#{p[0]}='#{p[1]}'" }.join(', ')
    sql = <<-SQL
      UPDATE #{table}
      SET #{s}
      WHERE id=#{id}
    SQL
    @@db.query(sql)
  end

  private
  def encrypt_password
    salt = BCrypt::Engine.generate_salt
    self.password_salt = salt
    self.password_hash = BCrypt::Engine::hash_secret(password, salt)
  end

  class << self
    def find_by(field, value)
      value = @@db.escape(value)
      table = 'users'
      sql = <<-SQL
        SELECT * FROM #{table}
        WHERE #{field}='#{value}'
        LIMIT 1
      SQL
      res = @@db.query(sql)
      res.map(&method(:new)).first
    end
  end
end

