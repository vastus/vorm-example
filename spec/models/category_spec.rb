require 'spec_helper'

describe Category do
  let(:category) {
    Category.new(
      name: 'General', 
      description: 'General discussion. Can be anything.'
    )
  }

  before { Category.destroy_all }
  after(:all) { Category.destroy_all }

  it "knows its table" do
    expect(Category.table).to eq(:categories)
  end

  its "instance knows its table" do
    expect(subject.table).to eq(:categories)
  end

  describe "#id" do
    it "responds to it" do
      expect(subject).to respond_to(:id)
    end

    it "is nil when record not saved" do
      expect(subject.id).to be_nil
    end

    xit "is the id generated by the db" do
      category.save
      expect(category.id).to eq(1)
    end
  end

  describe "#errors" do
    it "responds to it" do
      expect(subject).to respond_to(:errors)
    end

    it "is writable" do
      expect(subject).to respond_to(:errors=)
    end
  end

  context "fields" do
    let(:fields) { [:name, :description] }

    it "has the correct fields" do
      fields.each do |field|
        expect(subject).to respond_to(field)
      end
    end

    its "every field is writable" do
      fields.each do |field|
        expect(subject).to respond_to("#{field}=")
      end
    end

    describe "#name" do
      it "is required" do
        expect(subject).not_to be_valid
        expect(subject.errors).to include(:name)
      end

      it "cannot be empty" do
        subject.name = ''
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include("cannot be empty")
      end

      it "must be unique" do
        category.save
        another_category = Category.new(name: category.name)
        expect(another_category).not_to be_valid
      end

      it "cannot be taken" do
        category.save
        another_category = Category.new(name: category.name)
        expect(another_category).not_to be_valid
        expect(another_category.errors[:name]).to include("must be unique")
      end

      it "is valid when given" do
        subject.name = 'General'
        subject.valid?
        expect(subject.errors).not_to include(:name)
      end

      # it "can be updated"
    end

    describe "#description" do
      it "is required" do
        expect(subject).not_to be_valid
        expect(subject.errors).to include(:description)
      end

      it "cannot be empty" do
        subject.description = ''
        expect(subject).not_to be_valid
        expect(subject.errors[:description]).to include("cannot be empty")
      end

      its "max length is 256" do
        subject.description = 'K' * 256
        expect(subject).not_to be_valid
        expect(subject.errors[:description]).to include("cannot be longer than 255")
      end
    end
  end

  describe "#save" do
    let(:invalid_category) { Category.new }

    it "returns false when record is invalid" do
      expect(invalid_category.save).to be(false)
    end

    xit "returns user when record is valid" do
      expect(category.save.class).to eq(Category)
    end

    it "saves the record to the database" do
      expect { category.save }.to change(Category, :count).by(1)
    end

    it "sets the id attribute" do
      category.save
      expect(category.id).not_to be_nil
    end
  end

  describe "#update_attribute" do
    it "responds to it" do
      expect(subject).to respond_to(:update_attribute)
    end

    it "leaves the object untouched when key is nil" do
      name = category.name
      desc = category.description
      category.update_attribute(nil, :value)
      expect(category.name).to eq(name)
      expect(category.description).to eq(desc)
    end

    it "raises and error if the key isn't an instance method" do
      expect {
        subject.update_attribute(:wat, 'is')
      }.to raise_error(NoMethodError)
    end

    it "updates the correct attributes value" do
      category.update_attribute(:name, 'Major')
      expect(category.name).to eq('Major')
    end
  end

  describe "#update_attributes" do
    it "responds to it" do
      expect(subject).to respond_to(:update_attributes)
    end

    it "updates the correct attributes' values" do
      category.update_attributes(name: 'Major', description: 'Major Lazer')
      expect(category.name).to eq('Major')
      expect(category.description).to eq('Major Lazer')
    end
  end

  describe "#update" do
    # it "responds to it" do
    #   expect(subject).to respond_to(:update)
    # end

    # it "updates name when give" do
    #   category.save
    #   p category.update(name: "Generale")
    #   #expect(category.name).to eq("Generale")
    # end
  end

  describe "#new_record?" do
    # it "responds to it" do
    #   expect(subject).to respond_to(:new_record?)
    # end

    # it "returns false if the record hasn't been saved" do
    #   expect(subject).to be_new_record
    # end

    # it "returns true fi the record has been saved" do
    #   category.save
    #   expect(category).not_to be_new_record
    # end
  end

  describe ".find" do
    it "responds to it" do
      expect(Category).to respond_to(:find)
    end

    xit "raises an exception when not found"

    it "returns an object when found" do
      category.save
      found = Category.find(1)
      expect(found.id).to eq(1)
      expect(found.name).to eq(category.name)
      expect(found.description).to eq(category.description)
    end
  end

  describe ".find_by" do
    it "finds by name" do
      category.save
      found = Category.find_by(:name, 'General')
      expect(found.name).to eq(category.name)
    end
  end
end

