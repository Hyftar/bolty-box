module DirectoriesHelper
  def public_text(directory)
    directory.public? ? 'public' : 'private'
  end

  def owner_alias(directory)
    directory.owner == current_user ? 'me' : directory.owner.full_name
  end
end
