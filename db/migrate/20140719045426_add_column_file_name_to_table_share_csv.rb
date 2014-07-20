class AddColumnFileNameToTableShareCsv < ActiveRecord::Migration
  def change
  	add_column :csv_for_shares, :original_file_name, :string
  end
end
