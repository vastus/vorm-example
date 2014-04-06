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

  # validates :name, -> (cat) do
  #   if cat.name && !self.find_by(:name, cat.name).nil?
  #     "must be unique"
  #   end
  # end

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

  def update(params)
    self.name = params[:name] if params[:name]
    self.description = params[:description] if params[:description]
    k = [:name, :description]
    v = [name, description]
    update_with(self.id, k, v)
  end
end

