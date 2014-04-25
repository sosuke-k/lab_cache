class Item < ActiveRecord::Base
  belongs_to :user
  validates :title, uniqueness: true
  default_scope -> { order('created_at DESC') }
  has_many :reader
end
