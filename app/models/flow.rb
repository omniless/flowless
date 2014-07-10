class Flow
  include Mongoid::Document
  include Mongoid::Timestamps
  include Followable

  embeds_many :field_types, class_name: 'FieldType',  inverse_of: 'flow'
  accepts_nested_attributes_for :field_types, allow_destroy: true, :reject_if => :all_blank#, reject_if: ->(attributes) { attributes['xx'].blank? }

  embeds_many :steps,       class_name: 'Step',       inverse_of: 'flow'
  embeds_many :transitions, class_name: 'Transition', inverse_of: 'flow'

  has_many    :items, class_name: 'Item', inverse_of: 'flow',  validate: false

  belongs_to  :user,  class_name: 'User', inverse_of: 'flows', validate: false, index: true
  validates :user, presence: true

  field :name, type: String
  validates :name, presence: true

  field :description, type: String # information destined to the manager of the flow

  field :help_info, type: String # information destined to the final user

  scope :available_to, ->(user) { where(:user_id => user.id) }

  def valid_statuses
    steps.map &:name
  end
end
