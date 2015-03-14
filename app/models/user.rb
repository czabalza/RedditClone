class User < ActiveRecord::Base
  validates :name, :password_digest, :session_token, presence: true
  validates :name, :password_digest, :session_token, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token

  attr_reader :password

  has_many(
    :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    primary_key: :id
  )

  has_many(
    :posts,
    class_name: "Post",
    foreign_key: :author_id,
    primary_key: :id
  )

  def self.find_by_credentials(name, password)
    user = User.find_by_name(name)
    return nil unless user
    return user if user.is_password?(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest) == password
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

end
