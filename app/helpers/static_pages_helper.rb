module StaticPagesHelper

  def full_title(title)
    @title = 'Bolty-box'
    if title == ""
      title
    else
      "#{title}-#{@title}"
    end
  end
end
