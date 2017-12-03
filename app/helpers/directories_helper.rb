module DirectoriesHelper
  def public_text(directory)
    directory.public? ? 'public' : 'private'
  end

  def asset_public_text(asset)
    asset.directory.public? ? 'public' : 'private'
  end

  def owner_alias(directory)
    directory.owner == current_user ? 'me' : directory.owner.full_name
  end

  def asset_owner_alias(asset)
    asset.directory.owner == current_user ? 'me' : asset.directory.owner.full_name
  end
end
