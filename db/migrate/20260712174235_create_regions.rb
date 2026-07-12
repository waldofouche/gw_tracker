class CreateRegions < ActiveRecord::Migration[8.1]
  def change
    create_table :regions do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
