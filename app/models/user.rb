# representation for a human who can access the application
class User < ActiveRecord::Base
  authenticates_with_sorcery!
  validates_presence_of :name, :role, :email

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates_uniqueness_of :email

  belongs_to :role
end
