class AddPollsToWard < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :transportation_rating, :float
    add_column :wards, :shopping_rating, :float
    add_column :wards, :entertainment_rating, :float
    add_column :wards, :security_rating, :float
    add_column :wards, :natural_disaster_safety_rating, :float
    add_column :wards, :housing_cost_satisfaction_rating, :float
  end
end
