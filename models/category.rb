require_relative '../lib/model'
require_relative '../models/topic'

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

  validates :name, -> (cat) do
    if cat.name
      found = self.find_by(:name, cat.name)
      if cat.new_record? && found
        return "must be unique"
      end

      if !cat.new_record? && found && cat.id != found.id
        return "must be unique"
      end
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

  def topics
    Topic.where(category_id: id)
  end

  def replies
    sql = <<-SQL
      SELECT r.message, r.user_id FROM replies r
      INNER JOIN topics t
        ON r.topic_id = t.id
      WHERE t.category_id = #{id}
    SQL
    res = ORM::DB.query(sql)
    res.map { |reply_attrs| Reply.new(reply_attrs) }
  end
end

