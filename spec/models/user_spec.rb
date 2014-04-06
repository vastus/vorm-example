require 'spec_helper'

describe User do
  before do
    User.destroy_all
  end

  after(:all) do
    User.destroy_all
  end

  it "class knows its table" do
    expect(User.table).to eq(:users)
  end

  it "instance knows its table" do
    expect(subject.table).to eq(:users)
  end

  describe "#id" do
    it "responds to it" do
      expect(subject).to respond_to(:id)
    end
  end

  describe "#errors" do
    it "responds to it" do
      expect(subject).to respond_to(:errors)
    end
  end

  context "fields" do
    describe "#username" do
      it "responds to it" do
        expect(subject).to respond_to(:username)
      end

      it "sets it correctly thru username=()" do
        subject.username = 'testos'
        expect(subject.username).to eq('testos')
      end

      it "sets it correctly thru constructor" do
        user = User.new(username: 'testos')
        expect(user.username).to eq('testos')
      end

      it "is required" do
        subject.valid?
        expect(subject.errors[:username]).not_to be_nil
      end

      it "has an error message when not present" do
        subject.valid?
        expect(subject.errors[:username]).to include('cannot be empty')
      end

      it "has an error message when too short" do
        subject.username = 'bo'
        subject.valid?
        expect(subject.errors[:username]).to include('too short')
      end
    end

    describe "#email" do
      it "responds to it" do
        expect(subject).to respond_to(:email)
      end

      it "sets it correctly thru email=()" do
        subject.email = 'testos@teroni.fi'
        expect(subject.email).to eq('testos@teroni.fi')
      end

      it "sets it correctly thru constructor" do
        user = User.new(email: 'testos@teroni.fi')
        expect(user.email).to eq('testos@teroni.fi')
      end

      it "is required" do
        subject.valid?
        expect(subject.errors[:email]).not_to be_nil
      end

      it "has an error message when not present" do
        subject.valid?
        expect(subject.errors[:email]).to include('cannot be empty')
      end
    end

    describe "#password" do
      let(:password) { 'S3cret0s' }

      it "responds to it" do
        expect(subject).to respond_to(:password)
      end

      it "can be set using the setter" do
        subject.password = password
        expect(subject.password).to eq(password)
      end

      it "can be set using the constructor" do
        user = User.new(password: password)
        expect(user.password).to eq(password)
      end

      it "is required (when creating a new record)" do
        subject.valid?
        expect(subject.errors[:password]).not_to be_empty
      end

      it "has an error message when not present" do
        subject.valid?
        expect(subject.errors[:password]).to include('cannot be empty')
      end

      it "is valid when passwords match" do
        subject.password = subject.password_confirmation = password
        subject.valid?
        expect(subject.errors[:password]).to be_empty
      end
    end

    describe "#password_confirmation" do
      let(:password) { 'S3cret0s' }
      
      it "responds to it" do
        expect(subject).to respond_to(:password_confirmation)
      end

      it "can be set using the setter" do
        subject.password_confirmation = password
        expect(subject.password_confirmation).to eq(password)
      end

      it "can be set using the constructor" do
        user = User.new(password_confirmation: password)
        expect(user.password_confirmation).to eq(password)
      end

      it "is required" do
        subject.valid?
        expect(subject.errors[:password_confirmation]).not_to be_empty
      end

      it "has an error message when not present" do
        subject.valid?
        expect(subject.errors[:password_confirmation]).to include('cannot be empty')
      end

      it "has an error message when passwords don't match" do
        subject.password = password
        subject.password_confirmation = password + 'o'
        subject.valid?
        expect(subject.errors[:password_confirmation]).to eq(["passwords don't match"])
      end

      it "is valid when passwords match" do
        subject.password = subject.password_confirmation = password
        subject.valid?
        expect(subject.errors[:password_confirmation]).to be_empty
      end
    end
  end

  describe "#save" do
    let(:valid_user) { User.new(username: 'testos', 
                                email: 'testos@teroni.fi',
                                password: 'S3cret0s',
                                password_confirmation: 'S3cret0s') }

    let(:invalid_user) { User.new }

    it "returns false when record is invalid" do
      expect(invalid_user.save).to be(false)
    end

    it "returns user when record is valid" do
      expect(valid_user.save.class).to eq(User)
    end

    it "saves the record to the database" do
      expect { valid_user.save }.to change(User, :count).by(1)
    end
  end
end

