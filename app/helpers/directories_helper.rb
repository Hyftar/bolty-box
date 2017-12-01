module DirectoriesHelper

  def public_text(directory)
    directory.public? ? 'public' : 'private'
  end

end
