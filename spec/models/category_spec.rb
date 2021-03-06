require 'spec_helper'

describe Category do
  let(:cat_params) {
    {'name' => 'General', 'description' => 'General discussion. Can be anything.'}
  }

  let(:category) { Category.new(cat_params) }

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

    it "is not nil when record saved" do
      category.save
      expect(category.id).not_to be_nil
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

    it "returns true when record is valid" do
      expect(category.save).to be(true)
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
    before { category.save }

    it "responds to it" do
      expect(subject).to respond_to(:update)
    end

    it "returns false when new record" do
      expect(subject.update(name: "Ye")).to be(false)
    end

    it "keeps the id as it is" do
      expect { category.update(name: 'Edith') }.not_to change(category, :id)
    end

    it "updates name when given" do
      category.update(name: "Changed")
      expect(category.name).to eq("Changed")
    end

    it "validates before updating db" do
      category.update(name: '')
      expect(category.errors[:name]).to include("cannot be empty")
    end

    it "returns true when updating w/ the same name as before" do
      name = category.name
      ret = category.update(name: name)
      expect(ret).to be(true)
    end

    it "returns false when updating w/ a name that already exists" do
      another_category = Category.new(name: 'Boiler', description: 'This will not have a unique name when updated.')
      ret = another_category.update(name: category.name)
      expect(ret).to be(false)
    end

    it "sets the new name even if it is in use already" do
      another_category = Category.new(name: 'Boiler', description: 'This will not have a unique name when updated.')
      another_category.save
      another_category.update(name: category.name)
      expect(another_category.name).to eq(category.name)
    end

    it "is not valid when updating w/ a name that already exists" do
      another_category = Category.new(name: 'Boiler', description: 'This will not have a unique name when updated.')
      another_category.save
      ret = another_category.update(name: category.name)
      expect(another_category).not_to be_valid
    end

    it "sets the correct error when updating w/ a name that already exists" do
      another_category = Category.new(name: 'Boiler', description: 'This will not have a unique name when updated.')
      another_category.save
      another_category.update(name: category.name)
      expect(another_category.errors[:name]).to eq(["must be unique"])
    end

    it "doesn't update the name in db if invalid" do
      name = category.name
      category.update(name: '')
      expect(Category.find(category.id).name).to eq(name)
    end

    it "it returns true on valid update" do
      ret = category.update(name: 'Generale')
      expect(ret).to eq(true)
    end
  end

  describe "#new_record?" do
    it "responds to it" do
      expect(subject).to respond_to(:new_record?)
    end

    it "returns false if the record hasn't been saved" do
      expect(subject).to be_new_record
    end

    it "changes when saved" do
      expect { category.save }.to change(category, :new_record?)
    end

    it "returns true if the record has been saved" do
      category.save
      expect(category).not_to be_new_record
    end
  end

  context "privates" do
    describe "#_last_id" do
      it "returns the correct id when one row inserted" do
        category.save
        expect(subject.send(:_last_id)).to eq(category.id)
      end

      it "returns the last inserted rows id" do
        category.save
        Category.new(name: 'Add', description: 'Me').save
        last = Category.new(name: 'And', description: 'Me')
        last.save
        expect(subject.send(:_last_id)).to eq(last.id)
      end
    end

    describe "#_find" do
      it "responds to it" do
        expect { subject.send(:_find, 1) }.not_to raise_error
      end

      it "returns a hash of attributes as keys and values as vals" do
        category.save
        expect(category.send(:_find, category.id)).to eq(cat_params.merge('id' => category.id))
      end
    end
  end

  describe ".find" do
    it "responds to it" do
      expect(Category).to respond_to(:find)
    end

    it "raises an exception when not found" do
      id = 0
      expect { Category.find(id) }
        .to raise_error(ORM::RecordNotFound, "Category not found with id=#{id}")
    end

    it "returns an object when found" do
      category.save
      found = Category.find(category.id)
      expect(found.id).to eq(category.id)
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

  describe ".create" do
    it "exists" do
      expect(Category).to respond_to(:create)
    end

    it "takes a hash as an argument" do
      expect { Category.create({}) }.not_to raise_error
    end

    # xit "calls new with the given params"

    it "returns a new category" do
      created = Category.create
      expect(created).to be_instance_of(Category)
    end

    # xit "calls save"

    it "saves the created object to the db" do
      expect { Category.create(cat_params) }.to change(Category, :count).by(1)
    end

    it "return a new category w/ the right values" do
      created = Category.create(cat_params)
      expect(created.name).to eq(category.name)
      expect(created.description).to eq(category.description)
    end
  end

  context "relations" do
    describe "#topics" do
      before { category.save }

      let(:another_category) { Category.create(name: "Another", description: "Dummy category description") }

      let(:topic_params) {
        {title: "Present yourself", body: "Say your name, see my name.", category_id: category.id}
      }

      let(:topic) { Topic.new(topic_params) }

      let(:another_topic) { Topic.new(topic_params.merge(category_id: another_category.id)) }

      it "method exists" do
        expect(subject).to respond_to(:topics)
      end

      it "returns an empty array when no topics found" do
        expect(category.topics).to eq([])
      end

      it "returns an empty array when no topics found under this category" do
        another_topic.save
        expect(category.topics).to eq([])
      end

      it "returns a singleton array w/ topic that belongs to this category" do
        topic.save
        another_topic.save
        found = category.topics
        expect(found[0].title).to eq(topic.title)
        expect(found[0].body).to eq(topic.body)
        expect(found[0].category_id).to eq(topic.category_id)
      end
    end

    describe "#replies" do
      before { category.save }

      let(:another_category) { Category.create(name: "Another", description: "Dummy category description") }

      it "exists" do
        expect(category).to respond_to(:replies)
      end

      it "returns an empty array when no replies exist" do
        expect(category.replies).to eq([])
      end
    end
  end
end

