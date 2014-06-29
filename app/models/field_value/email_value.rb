class FieldValue
  class EmailValue < ::FieldValue
    include Mongoid::Document

    SINGLE_EMAIL_REGEXP   = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+\z/ # Taken directly from Devise.email_regexp but make sure no , are present in email
    MULTIPLE_EMAIL_REGEXP = /\A[^@\s,]+@([^@\s,]+\.)+[^@\s,]+(\s*,\s*[^@\s,]+@([^@\s,]+\.)+[^@\s,]+)*\z/ # allowing emails separated with , and spaces

    delegate :multiple_email_allowed?, :blocked_keywords, :default_value, to: :field_type

    field     :value, type: String

    validates :value, format: { with: SINGLE_EMAIL_REGEXP },   allow_nil: true, unless: ->{ multiple_email_allowed? } # allowing nil is important in case there are no value provided (when optional)
    validates :value, format: { with: MULTIPLE_EMAIL_REGEXP }, allow_nil: true, if:     ->{ multiple_email_allowed? } # allowing nil is important in case there are no value provided (when optional)

    validate :forbidden_keyword_validation, unless: ->{ blocked_keywords.empty? }

    # TOTEST
    def forbidden_keyword_validation
      errors.add :value, I18n.t('errors.messages.exclusion') if value =~ /(#{blocked_keywords.join('|')})/
    end
  end
end