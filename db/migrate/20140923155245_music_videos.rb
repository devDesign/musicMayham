class MusicVideos < ActiveRecord::Migration
  def change
    change_table :music_videos do |t|
      t.timestamps
    end
  end
end
