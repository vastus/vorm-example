require 'bcrypt'

require_relative '../lib/model'

class User < ORM::Model
  # Table name.
  table :users

  # Fields for model.
  fields :email, :username, :role, :password_hash, :password_salt

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

  validates :role, -> (user) do
    if user.role.nil? || user.role.to_s.strip.empty?
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
    encrypt_password
    super()
  end

  def role?(role)
    self.role == role.to_s
  end

  def unread
    sql = <<-SQL
      SELECT t.id, t.title, t.body, t.user_id, t.category_id FROM topics t
      JOIN readtopics r
        ON r.topic_id = t.id
      WHERE t.user_id != #{self.id}
    SQL
    res = ORM::DB.query(sql)
    res.map { |topic_attrs| Topic.new(topic_attrs) }
  end

  private
  def encrypt_password
    salt = BCrypt::Engine.generate_salt
    self.password_salt = salt
    self.password_hash = BCrypt::Engine::hash_secret(password, salt)
  end
end

