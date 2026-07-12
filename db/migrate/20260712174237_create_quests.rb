class CreateQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :quests do |t|
      t.references :region, null: false, foreign_key: true
      t.string :name
      t.integer :quest_type
      t.integer :position
      t.text :description

      t.timestamps
    end
  end
end
