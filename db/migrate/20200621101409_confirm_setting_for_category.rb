# frozen_string_literal: true
class ConfirmSettingForCategory < ActiveRecord::Migration[6.0]
  def up
    user_field = { "name" => "", "field_type" => "confirm", "created_at" => nil, "updated_at" => nil, "editable" => true, "description" => "Allow site to change your notification level of frequently visited categories", "required" => false, "show_on_profile" => false, "position" => 0, "show_on_user_card" => false, "external_name" => nil, "external_type" => nil }
    user_field_setting = UserField.new(user_field)
    user_field_setting.save
    PluginStore.set('discourse-notifier', 'field_category_id', user_field_setting.id)
  end

  def down
    name = "user_field_#{PluginStore.get('discourse-notifier', 'field_category_id')}"
    execute 'delete from user_custom_fields where name = name'
  end
end
