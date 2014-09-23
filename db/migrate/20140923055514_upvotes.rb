class Upvotes < ActiveRecord::Migration
  def change
    remove_column(:upvotes, :total_upvotes)
    remove_column(:upvotes, :total_downvotes)
  end
end
