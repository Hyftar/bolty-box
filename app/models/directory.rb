class Directory < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :assets
  belongs_to :user
  belongs_to :directory, optional: true

  alias_attribute :parent, :directory
  alias_attribute :owner, :user
  alias_attribute :shared_with, :users
  alias_attribute :public?, :public

  validates :name, presence: true

  before_destroy do |record|
    record.assets.destroy_all
    Directory.where(parent: self).destroy_all
  end

  def shared_with?(user)
    return true if user.admin?
    ActiveRecord::Base
      .connection
      .execute(
        "SELECT CAST(COUNT(*) AS BIT)
        FROM directories_users
        WHERE user_id = #{user.id} AND directory_id = #{id}
        LIMIT 1"
      )[0][0].nonzero?
  end

  def children_shared_with(user)
    if user.admin?
      Directory.where(parent: self)
    else
      Directory.find_by_sql("
        SELECT *
        FROM directories
        WHERE directory_id = #{id} AND (
          public = 't'
          OR
          user_id = #{user.id}
          OR
          id IN
          (SELECT directory_id
            FROM directories_users
            WHERE user_id = #{user.id}
          )
        )
      ")
    end
  end
end
