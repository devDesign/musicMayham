class User < ActiveRecord::Base
  has_many :upvotes
  has_many :downvotes
  has_many :music_videos
  validates :username, uniqueness: true
end