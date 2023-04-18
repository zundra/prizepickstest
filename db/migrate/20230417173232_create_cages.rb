class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.integer :diet_id
      t.integer :max_capacity, default: 500
      t.string :power_state, default: POWER_STATES[:down]

      t.timestamps
    end
  end
end
