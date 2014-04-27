class User < ActiveRecord::Base
  validates :twitter_id, uniqueness: true
  validates :twitter_id, presence: true
  validates :image_url, presence: true
  has_many :reader
  has_many :comments
end
