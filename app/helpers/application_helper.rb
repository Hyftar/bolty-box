module ApplicationHelper
  def application_title
    Rails.application.class.parent_name.titleize.split.join('-')
  end

  def full_title(title)
    title.empty? ? application_title : "#{title} | #{application_title}"
  end
end
