# frozen_string_literal: true
module Jobs

  class NotificationLevelUpdater < ::Jobs::Scheduled
    word = SiteSetting.discourse_notifier_select_cron_pattern
    SiteSetting.discourse_notifier_select_cron_pattern_value.to_i == 1 ?
    (every 1.public_send(word)) :
    (every SiteSetting.discourse_notifier_select_cron_pattern_value.public_send(word + 's'))

    def execute(_args)
      name = "user_field_#{PluginStore.get('discourse-notifier', 'field_category_id')}"
      user_ids = User.where(id: (UserCustomField.where(name: name).where(value: "true").pluck(:user_id)))

      user_ids.each do |user_id|
        category_ids = get_category_ids(user_id.id)
        frequent_category_ids = get_frequent_ids(category_ids, SiteSetting.discourse_notifier_top_n_categories.to_i)
        set_notification_for_category(user_id, frequent_category_ids)
      end

      name = "user_field_#{PluginStore.get('discourse-notifier', 'field_tag_id')}"
      user_ids = User.where(id: (UserCustomField.where(name: name).where(value: "true").pluck(:user_id)))

      user_ids.each do |user_id|
        tag_ids = get_tag_ids(user_id.id)
        frequent_tag_ids = get_frequent_ids(tag_ids, SiteSetting.discourse_notifier_top_n_tags.to_i)
        set_notification_for_tag(user_id, frequent_tag_ids)
      end

    end

    private

    def get_category_ids(user_id)
      Topic.where(id: (TopicUser.where("last_visited_at > ?", SiteSetting.discourse_notifier_select_n_week_data.to_i.week.ago.utc).where(user_id: user_id).pluck(:topic_id))).pluck(:category_id)
    end

    def get_tag_ids(user_id)
      TopicTag.where(topic_id: (TopicUser.where("last_visited_at > ?", SiteSetting.discourse_notifier_select_n_week_data.to_i.week.ago.utc).where(user_id: user_id).pluck(:topic_id))).pluck(:tag_id)
    end

    def set_notification_for_category(user_id, frequent_category_ids)
      return if user_id.empty?
      frequent_category_ids.each do |category_id|
        level = SiteSetting.discourse_notifier_set_category_notification_level.to_i
        CategoryUser.set_notification_level_for_category(user_id, level, category_id)
      end

    end

    def set_notification_for_tag(user_id, frequent_tag_ids)
      return if user_id.empty?
      frequent_tag_ids.each do |tag_id|
        level = SiteSetting.discourse_notifier_set_tag_notification_level.to_i
        TagUser.change(user_id, tag_id, level)
      end

    end

    def get_frequent_ids(ids, frequency)
      ids = ids - [nil]
      return if ids.empty?
      counts = Hash.new(0)

      ids.each do |id|
        counts[id] += 1
      end

      max = 0
      largest = []

      if (frequency > counts.size)
        frequency = counts.size
      end

      maxarray = []

      for j in 0 .. frequency - 1 do
        maxhash = counts.max_by { |k, v| v }
        maxarray << maxhash.first
        counts.delete(maxhash.first)
      end

      maxarray.flatten.map(&:to_i)
    end
  end
end
