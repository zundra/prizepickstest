class CreateDiets < ActiveRecord::Migration[7.0]
  def change
    create_table :diets do |t|
      t.string :name
      t.timestamps
    end

    add_index :diets, [:name], unique: true
  end
end
