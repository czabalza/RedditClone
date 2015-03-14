module ApplicationHelper
  def all_subs(post)
    sub_list = post.subs.pluck(:id)
  end
end
