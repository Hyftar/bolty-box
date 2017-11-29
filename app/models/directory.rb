class Directory < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :assets
  belongs_to :user
  belongs_to :directory, optional: true
end
