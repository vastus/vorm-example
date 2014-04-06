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

    # it "is only readable" do
    #   expect(subject).not_to respond_to(:id=)
    # end
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

      it "is valid when given" do
        subject.name = 'General'
        subject.valid?
        expect(subject.errors).not_to include(:name)
      end
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

    it "returns user when record is valid" do
      expect(category.save.class).to eq(Category)
    end

    it "saves the record to the database" do
      expect { category.save }.to change(Category, :count).by(1)
    end
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
end

