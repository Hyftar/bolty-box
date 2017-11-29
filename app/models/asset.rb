class Asset < ApplicationRecord
  belongs_to :directory
  has_attached_file(
    :file,
    url: 'assets/:id/download/',
    path: 'db/assets/:id_:filename',
    preserve_files: false,
    adapter_options: { hash_digest: Digest::MD5 }
  )
end
