# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digist :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, :password_digist, presence: :true
  validates :username, uniqueness: true
  validates :password_digist, lenght: { minimum: 6, allow_nil: true }

  after_validation :ensure_session_token

  attr_reader :password

  def self.find_by_credential(username, password)
    user = User.find_by_username(username)
    return user if user && user.is_passwrod?(password)
    nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def is_passwrod?(password)
    BCrypt::Password.new(self.password_digist) == password
  end

  def password=(password)
    @password = password
    self.password_digist = BCrypt::Password.create(password)
  end



  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end
