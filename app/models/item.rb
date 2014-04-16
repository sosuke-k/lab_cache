class Item < ActiveRecord::Base
  belongs_to :user
  validates :url, uniqueness: true
  default_scope -> { order('created_at DESC') }

  searchable do
    text :title
    text :content
  end
end
