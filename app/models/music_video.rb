class MusicVideo < ActiveRecord::Base
  belongs_to :users
  has_many :upvotes
  has_many :downvotes
  validates_presence_of :url
end