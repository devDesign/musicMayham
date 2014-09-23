class Downvote < ActiveRecord::Base
  belongs_to :user
  belongs_to :music_video
  validates_uniqueness_of :user_id, :scope => :music_video_id
end