class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :url, :text
      t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :videos
  end
end
