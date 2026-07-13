# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_12_195649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.string "wiki_anchor"
    t.string "wiki_page"
  end

  create_table "missions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "difficulty"
    t.string "name"
    t.integer "position"
    t.bigint "region_id", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_missions_on_region_id"
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "given_at"
    t.string "given_by"
    t.string "name"
    t.integer "position"
    t.string "profession"
    t.integer "quest_type"
    t.bigint "region_id", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_quests_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_regions_on_campaign_id"
  end

  add_foreign_key "missions", "regions"
  add_foreign_key "quests", "regions"
  add_foreign_key "regions", "campaigns"
end
