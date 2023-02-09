class CreateWards < ActiveRecord::Migration[7.0]
  def change
    create_table :wards do |t|
      t.string :name
      t.text :summary
      t.string :flag
      t.integer :one_ldk_avg_rent
      t.integer :two_ldk_avg_rent
      t.integer :three_ldk_avg_rent
      t.string :safety
      t.integer :school_ratings
      t.integer :population
      t.integer :population_density
      t.timestamps
    end
  end
end
