class AddColumnFileSize < ActiveRecord::Migration
  def change
  	change_column :csv_for_shares, :file_size, :string
  end
end
