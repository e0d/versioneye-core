class Notification < Versioneye::Model

  include Mongoid::Document
  include Mongoid::Timestamps

  A_CLASSI_NIL = nil

  field :version_id    , type: String
  field :read          , type: Boolean, default: false
  field :sent_email    , type: Boolean, default: false
  field :email_disabled, type: Boolean, default: false
  field :classification, type: String # nil for follow. Oterwise project.

  field :noti_type,  type: String, default: 'email' # [email, webhook]
  field :event_type, type: String # [security, license, version]

  field :email, type: String
  field :name,  type: String

  field :webhook,       type: String
  field :webhook_token, type: String

  belongs_to :user
  belongs_to :product

  index({product_id: 1, user_id: 1, version_id: 1}, { name: "prod_user_vers_index", background: true, unique: true, drop_dups: true })
  index({user_id: 1}, { name: "user_index", background: true})
  index({user_id: 1, sent_email: 1}, { name: "user_unsent_index", background: true})

  scope :no_classification, ->{where(classification: nil)}
  scope :all_not_sent     , ->{where(sent_email: false)}
  scope :by_user          , ->(user){where(user_id: user.id)}
  scope :by_user_id       , ->(user_id){where(user_id: user_id).desc(:created_at).limit(30)}


  def self.unsent_user_notifications( user )
    by_user( user ).where(sent_email: false, classification: nil)
  end


end
