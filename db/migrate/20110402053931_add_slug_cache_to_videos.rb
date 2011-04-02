class AddSlugCacheToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :cached_slug, :string
    add_index  :videos, :cached_slug, :unique => true
  end

  def self.down
    remove_index :videos, :column => :cached_slug
    remove_column :videos, :cached_slug
  end
end
