class Directory < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :assets
  belongs_to :user
  belongs_to :directory, optional: true

  alias_attribute :parent, :directory
  alias_attribute :owner, :user
  alias_attribute :shared_with, :users
  alias_attribute :public?, :public
end
