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
end

