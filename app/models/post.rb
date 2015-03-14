class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many :post_subs
  has_many :subs, through: :post_subs, source: :sub

  def all_subs_test
    sub_list = self.subs.pluck(:id)
    # sub_ids = subs.map { |ssub| ssub.id }
    # sub_ids
  end

end
