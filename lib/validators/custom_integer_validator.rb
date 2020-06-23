# frozen_string_literal: true

class CustomIntegerValidator
  def initialize(opts = {})
    @opts = opts
  end

  def valid_value?(val)
    num = val.to_i
    return false if num.to_s != val.to_s
    return false if num != 0 && num < 1
    true
  end

  def error_message
    I18n.t('site_settings.errors.invalid_integer_value', min: 1)
  end
end
