require_relative '../../models/user'

describe User do
  it "knows its db table's name" do
    expect(User.table).to eq(:users)
  end

  context "fields" do
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

    describe "#email" do
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
  end
end

