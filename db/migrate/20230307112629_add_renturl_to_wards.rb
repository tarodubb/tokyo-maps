class AddRenturlToWards < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :rent_url, :string
  end
end
