# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131019162040) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",       limit: 45
    t.text     "body",        limit: 2147483647
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.datetime "modified_at"
  end

  create_table "bonus_schemes", force: :cascade do |t|
    t.string   "reason"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "key_name"
  end

  create_table "bonuses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.float    "value"
    t.integer  "bonus_scheme_id"
    t.boolean  "claimed",         default: false, null: false
    t.boolean  "paid"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "eligibility"
    t.integer  "service_id"
    t.integer  "due_month"
    t.date     "payment_date"
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "title",       limit: 45,               null: false
    t.text     "description",                          null: false
    t.string   "type",        limit: 1,  default: "1", null: false
    t.text     "quiz_data"
    t.datetime "created_at",                           null: false
    t.datetime "modified_at",                          null: false
    t.datetime "deleted_at"
  end

  create_table "interaction", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "thread_id",              null: false
    t.string   "type",        limit: 45, null: false
    t.text     "comment",                null: false
    t.datetime "created_at",             null: false
    t.datetime "modified_at",            null: false
    t.datetime "deleted_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.boolean  "has_bonus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "abbr"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "client"
    t.string   "project_manager"
    t.integer  "hub_id"
    t.string   "sales_manager"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "budget",          default: 0
    t.integer  "converted",       default: 0
    t.integer  "engagement_type", default: 1
    t.text     "status_comment"
    t.integer  "abc"
  end

  create_table "service_types", force: :cascade do |t|
    t.string   "name"
    t.string   "key_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.integer  "service_type_id"
    t.integer  "project_id"
    t.text     "description"
    t.boolean  "spec_sent"
    t.boolean  "proposal_sent"
    t.date     "start_date"
    t.integer  "duration"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "sold_by",         default: 0,     null: false
    t.integer  "success_status",  default: 1,     null: false
    t.integer  "budget",          default: 0
    t.integer  "created_by"
    t.boolean  "is_paid",         default: false, null: false
    t.text     "status_comment"
  end

  create_table "thread", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.string   "profile",     limit: 45, default: "fan", null: false
    t.integer  "profile_id",                             null: false
    t.datetime "created_at",                             null: false
    t.datetime "modified_at",                            null: false
    t.datetime "deleted_at"
  end

  add_index "thread", ["user_id"], name: "index2"

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "song_id",    null: false
    t.float    "gross",      null: false
    t.float    "net",        null: false
    t.float    "tax",        null: false
    t.datetime "created_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "position_id"
    t.boolean  "is_admin",    default: false
    t.boolean  "has_bonus",   default: false
    t.boolean  "is_employed", default: true
    t.boolean  "is_manager",  default: false
    t.string   "avail_date"
  end

end
