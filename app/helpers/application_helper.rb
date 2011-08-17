module ApplicationHelper
  
  def display_user_name(user)
    link_to(user.name.blank? ? user.email : user.name, user)
  end
  
end
