require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  DEFAULT_COLOR = '#005A55'

  has_many :questions, dependent: :destroy

  before_create :user_color

  before_validation :username_downcase

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :username, length: {maximum: 40}
  validates :username, uniqueness: true
  validates_format_of :username, :with => /\A[\w]*\z+/
  validates_format_of :profile_color, :with => /\A\#[0-9a-f]{6}\z/

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      # создаем т.н. "соль" - рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаем хэш пароля - длинная уникальная строка, из которой невозможно восстановить
      # исходный пароль
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  # служебный метод, преобразующий бинарную строку в 16-ричный формат, для удобства хранения
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email) # сперва находим кандидата по email

    # ОБРАТИТЕ внимание: сравнивается password_hash, а оригинальный пароль так никогда
    # и не сохраняется нигде
    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end

  def username_downcase
    self.username.downcase!
  end

  def user_color
    if self.profile_color.nil?
      self.profile_color = DEFAULT_COLOR
    end
  end
end
