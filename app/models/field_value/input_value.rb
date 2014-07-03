class FieldValue
  class InputValue < ::FieldValue
    include Mongoid::Document

    delegate :validation_regexp, :min_char_count, :max_char_count, :default_value, :length_constraints?, to: :field_type

    field :value, type: String

    validates :value, format: { with: ->(v) { v.validation_regexp } }, allow_blank: true, if: ->{ validation_regexp } # allowing blank is important in case there are no value provided (when optional)

    validate  :value_length_constraints_validation, if: ->{ length_constraints? && !value.blank? } # making sure not to try the validation if the value is blank

    # WARNING this needs to support UTF-8 encoding - should be ok by default on Ruby 2+
    def value_length_constraints_validation
      errors.add :value, I18n.t('errors.messages.too_short') if min_char_count && value.size < min_char_count
      errors.add :value, I18n.t('errors.messages.too_long')  if max_char_count && value.size > max_char_count
    end

  end
end