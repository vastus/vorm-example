require 'spec_helper'

require_relative '../../models/read_topics'

describe Topic do
  before do
    Topic.destroy_all
    ReadTopics.destroy_all
  end

  after(:all) do
    Topic.destroy_all
    ReadTopics.destroy_all
  end

  describe "#save" do
    let(:topic) {
      Topic.create(
        title: 'Tis my hood',
        body: 'Oy, boyes tryen to kidda woulda',
        user_id: 666,
        category_id: 1
    )}

    it "saves its id and user_id to readtopics" do
      res = ReadTopics.all.map { |i| [i.user_id, i.topic_id] }
      p BEFORE: res
      topic.save
      res = ReadTopics.all.map { |i| [i.user_id, i.topic_id] }
      p AFTER: res

      expect { topic.save }.to change(Topic, :count).by(1)
    end
  end
end

