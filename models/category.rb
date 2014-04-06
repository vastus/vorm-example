require_relative '../lib/model'

class Category < ORM::Model
  # Table name.
  table :categories

  # Fields for model.
  fields :name, :description

  # Validations
  validates :name, -> (cat) do
    if cat.name.nil? || cat.name.strip.empty?
      "cannot be empty"
    end
  end

  validates :description, -> (cat) do
    if cat.name.nil? || cat.name.strip.empty?
      "cannot be empty"
    end
  end

  validates :description, -> (cat) do
    if cat.description && cat.description.length > 255
      "cannot be longer than 255"
    end
  end

  # def update(params)
  #   self.username = params[:username]
  #   self.email = params[:email]
  #   valid?
  #   if errors[:username].empty? && errors[:email].empty?
  #     return false
  #   end
  #   k = [:username, :email]
  #   v = k.map(&method(:send))
  #   s = (k.zip(v)).map{|p| "#{p[0]}='#{p[1]}'" }.join(', ')
  #   sql = <<-SQL
  #     UPDATE #{table}
  #     SET #{s}
  #     WHERE id=#{id}
  #   SQL
  #   @@db.query(sql)
  # end

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

