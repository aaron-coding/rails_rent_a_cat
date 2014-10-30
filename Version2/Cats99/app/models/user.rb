
class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token,
    presence: true
  # after_initialize :reset_session_token!

  # def reset_session_token!
#
#     session = Session.where(user_id: current_user.id, user_agent: user_agent).first
#     new_token = SecureRandom::urlsafe_base64(16)
#     if session
#       session.update(session_token: new_token)
#     else
#       Session.create(user_id: current_user.id,
#                      user_agent: user_agent,
#                      session_token: new_token
#                      )
#     end
#     self.session_token = new_token
#   end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = self.find_by(user_name: user_name)
    return unless user
    if user.is_password?(password)
      user
    else
      nil
    end
  end

  has_many :cat_rental_requests
  has_many(
    :cats
    # class_name: "Cat",
    # foreign_key: :user_id,
  )

end

