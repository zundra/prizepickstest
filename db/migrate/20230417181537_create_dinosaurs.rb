class CreateDinosaurs < ActiveRecord::Migration[7.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name
      t.integer :diet_id, null: false
      t.integer :species_id, null: false
      t.integer :cage_id
      t.timestamps
    end

    add_index :dinosaurs, [:name], unique: true
  end
end
