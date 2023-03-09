class AddPetPercentageToWard < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :pet_percentage, :float
  end
end
