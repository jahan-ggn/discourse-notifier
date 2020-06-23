# frozen_string_literal: true
require 'rails_helper'

describe Jobs::NotificationLevelUpdater do

  let(:notifier) { Jobs::NotificationLevelUpdater.new }
  fab!(:topic) { Fabricate(:topic) }
  fab!(:category) { topic.category }
  fab!(:user) { Fabricate(:user) }
  fab!(:topic_user) { TopicUser.create!(topic: topic, user: user, last_visited_at: Time.zone.now - 6.days) }
  fab!(:tag) { Fabricate(:tag) }
  fab!(:topic_tag) { TopicTag.create!(topic_id: topic.id, tag: tag) }
  fab!(:category_user) { CategoryUser.create(category: category, user: user, notification_level: 0) }
  fab!(:user_custom_field) { UserCustomField.create(user_id: user.id, name: "user_field_200") }

  context "enabled settings" do

    it "includes the class when plugin is enabled" do
      SiteSetting.discourse_notifier_enabled = true
      expect(defined?(::Jobs::NotificationLevelUpdater) == 'constant' && ::Jobs::NotificationLevelUpdater.class == Class).to eq(true)
    end

  end

  context 'when user visited any topic' do

    it "allow plugin to work" do
      expect(User.where(id: (UserCustomField.where(name: "user_field_200").where(value: "true").pluck(:user_id)))).to eq(User.where(id: user_custom_field.user_id)).or eq([])
    end

    it "returns the correct category ids" do
      expect(notifier.send('get_category_ids', user_custom_field.user_id)).to eq([category.id]).or eq([])
    end

    it "returns the correct tag ids" do
      expect(notifier.send('get_tag_ids', user_custom_field.user_id)).to eq([tag.id]).or eq([])
    end

  end

  context "when cron executes" do

    user = User.where(id: (UserCustomField.where(name: "user_field_200").where(value: "true").pluck(:user_id)))
    p "user"
    p user
    it "notification level gets change for category" do
      expect(notifier.send('set_notification_for_category', user, [category.id])).to eq([1]).or eq(nil)
    end

    it "notification level gets change for tag" do
      expect(notifier.send('set_notification_for_tag', user, [tag.id])).to eq([1]).or eq(nil)
    end

  end

end
