class Directory < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :assets
  belongs_to :user
  belongs_to :directory, optional: true

  alias_attribute :parent, :directory
  alias_attribute :owner, :user
  alias_attribute :shared_with, :users
  alias_attribute :public?, :public

  def shared_with?(user)
    if user.admin?
      true
    else
      ActiveRecord::Base
        .connection
        .execute(
          "SELECT CAST(COUNT(*) AS BIT)
          FROM directories_users
          WHERE user_id = #{user.id} AND directory_id = #{id}
          LIMIT 1"
        )[0][0].nonzero?
    end
  end

  def children_shared_with(user)
    if user.admin?
      Directory.where(parent: self)
    else
      Directory.where(id:
        ActiveRecord::Base
          .connection
          .execute(
            "SELECT id
             FROM directories
             WHERE directory_id = #{id} AND (
               public = 't'
               OR
               id IN
               (SELECT directory_id
                 FROM directories_users
                 WHERE user_id = #{user.id}
               )
             )
            "
          )
          .map { |x| x['id'] }
      )
    end
  end
end
