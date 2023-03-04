class AddSchoolInfoToWards < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :school_info, :jsonb
  end
end
