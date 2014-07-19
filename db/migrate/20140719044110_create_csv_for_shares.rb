class CreateCsvForShares < ActiveRecord::Migration
  def change
    create_table :csv_for_shares do |t|
      t.string :link_id
      t.text :data
      t.integer :file_size
      t.integer :num_lines
      t.string :download_link

      t.timestamps
    end

    add_index :csv_for_shares, :link_id
  end
end
