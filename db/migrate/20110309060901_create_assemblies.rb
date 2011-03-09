class CreateAssemblies < ActiveRecord::Migration
  def self.up
    create_table :assemblies do |t|
      t.integer :project_id, :unsigned => true
      t.integer :user_id, :unsigned => true
      t.string :assembly_id, :assembly_url
      t.boolean :processed
    end
  end

  def self.down
    drop_table :assemblies
  end
end
