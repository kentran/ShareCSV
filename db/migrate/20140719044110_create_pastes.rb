class CreatePastes < ActiveRecord::Migration
  def change
    create_table :pastes do |t|
      t.string :slug
      t.text :sample_data
      t.string :file_name
      t.integer :file_size
      t.integer :num_lines
      t.string :download_url

      t.timestamps
    end

    add_index :pastes, :slug, unique: true
  end
end
