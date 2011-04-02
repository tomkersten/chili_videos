class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :url, :text
      t.integer :project_id, :user_id, :version_id, :duration, :height, :width
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
