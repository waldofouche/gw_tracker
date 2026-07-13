class AddWikiMetadataToCampaigns < ActiveRecord::Migration[8.1]
  def change
    add_column :campaigns, :wiki_page, :string
    add_column :campaigns, :wiki_anchor, :string
  end
end
