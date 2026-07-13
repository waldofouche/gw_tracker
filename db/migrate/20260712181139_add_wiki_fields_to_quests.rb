class AddWikiFieldsToQuests < ActiveRecord::Migration[8.1]
  def change
    add_column :quests, :profession, :string
    add_column :quests, :given_by, :string
    add_column :quests, :given_at, :string
  end
end
