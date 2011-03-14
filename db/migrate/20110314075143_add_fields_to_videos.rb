class AddFieldsToVideos < ActiveRecord::Migration
  def self.up
    rename_column :videos, :name, :title
    add_column :videos, :user_id, :integer
    add_column :videos, :version_id, :integer
    add_column :videos, :duration, :integer
    add_column :videos, :height, :integer
    add_column :videos, :width, :integer
  end

  def self.down
    remove_column :videos, :width
    remove_column :videos, :height
    remove_column :videos, :duration
    remove_column :videos, :version_id
    remove_column :videos, :user_id
    rename_column :videos, :title, :name
  end
end
