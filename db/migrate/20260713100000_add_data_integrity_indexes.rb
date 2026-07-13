class AddDataIntegrityIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :campaigns, :slug, unique: true
    add_index :regions, %i[campaign_id name], unique: true
    add_index :missions, %i[region_id name], unique: true
    add_index :quests, %i[region_id name], unique: true
  end
end
