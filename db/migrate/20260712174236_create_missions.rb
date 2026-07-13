class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :missions do |t|
      t.references :region, null: false, foreign_key: true
      t.string :name
      t.integer :position
      t.integer :difficulty

      t.timestamps
    end
  end
end
