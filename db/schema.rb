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

ActiveRecord::Schema.define(version: 2021_07_16_182224) do

  create_table "artists", force: :cascade do |t|
    t.string "article"
    t.string "name"
    t.string "slug"
    t.index ["slug"], name: "index_artists_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "guests", force: :cascade do |t|
    t.string "name"
    t.integer "selection"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer "user_id"
    t.integer "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hosts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "guest_id"
    t.boolean "enabled"
    t.boolean "locked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string "article"
    t.string "name"
    t.integer "artist_id"
    t.integer "genre_id"
    t.integer "year"
    t.integer "gender"
    t.integer "vocal_parts"
    t.integer "vocal_percussion"
    t.integer "band_tier"
    t.integer "bass_tier"
    t.integer "drums_tier"
    t.integer "guitar_tier"
    t.integer "vocals_tier"
    t.boolean "cover"
    t.integer "duration"
    t.integer "bpm"
    t.integer "availability"
    t.integer "source"
    t.string "spotify_id"
    t.integer "psn_link"
    t.integer "xbox_link"
    t.integer "amazon_link"
    t.integer "itunes_link"
    t.integer "google_link"
    t.string "slug"
    t.index ["artist_id"], name: "index_songs_on_artist_id"
    t.index ["genre_id"], name: "index_songs_on_genre_id"
    t.index ["slug"], name: "index_songs_on_slug", unique: true
  end

  create_table "user_songs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "song_id"
    t.integer "rating"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end

end
