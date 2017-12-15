class Asset < ApplicationRecord
  after_create do |record|
    user = record.directory.owner
    unless user.admin?
      user.space_used += record.file_file_size
      user.save
    end
  end

  before_destroy do |record|
    user = record.directory.owner
    unless user.admin?
      user.space_used -= record.file_file_size
      user.save
    end
  end

  belongs_to :directory
  has_attached_file(
    :file,
    url: 'assets/:id/download/',
    path: 'db/assets/:id_:filename',
    preserve_files: false,
    adapter_options: { hash_digest: Digest::MD5 }
  )

  do_not_validate_attachment_file_type :file
  validates :file, presence: { message: 'cannot be empty.' }
  validate :file_size_cannot_be_greater_than_available_space

  def file_size_cannot_be_greater_than_available_space
    return if file_file_size.nil?
    user = directory.owner
    space_left = user.max_space - user.space_used
    return unless file_file_size > space_left
    errors.add(:file, 'is too big, you lack the required space to save it.')
  end
end
