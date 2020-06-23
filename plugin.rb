# frozen_string_literal: true

# name: discourse-notifier
# about:
# version: 0.1
# authors: Jahan Gagan
# url: https://github.com/jahan-ggn/discourse-notifier.git

enabled_site_setting :discourse_notifier_enabled
PLUGIN_NAME ||= 'discourse-notifier'

require File.expand_path('../lib/validators/custom_integer_validator.rb', __FILE__)
after_initialize do
  # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb

  if SiteSetting.discourse_notifier_enabled

    if SiteSetting.discourse_notifier_select_cron_pattern_value.to_i != 0 && (SiteSetting.discourse_notifier_top_n_categories.to_i != 0 || SiteSetting.discourse_notifier_top_n_tags != 0.to_i)
      # requiring a plugin
      require File.expand_path('../jobs/scheduled/notification_level_updater.rb', __FILE__)
    end

  end

end
