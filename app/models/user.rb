class User < ApplicationRecord
  validates :given_name, presence: true, format: { with: /\A[[:alpha:]\- ]{2,}\z/ }
  validates :last_name, presence: true, format: { with: /\A[[:alpha:]\- ]{2,}\z/ }

  has_and_belongs_to_many :directories
  has_many :assets, through: :directories

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable

  alias_attribute :admin?, :admin

  def full_name
    "#{given_name} #{last_name}"
  end

  def allowed_to_browse?(directory)
    directory.public? ||
      admin? ||
      directory.owner == self ||
      directory.shared_with?(self)
  end

  def owner?(directory)
    directory.owner == self || admin?
  end
end
