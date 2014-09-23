class Downvotes < ActiveRecord::Migration
  def change
    change_table :downvotes do |t|
    t.references :user
    end 
  end
end
