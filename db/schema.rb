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

ActiveRecord::Schema.define(version: 20171125233252) do

  create_table "btc_balances", force: :cascade do |t|
    t.float    "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btcs", force: :cascade do |t|
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "index"
  end

  create_table "cads", force: :cascade do |t|
    t.integer  "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eth_balances", force: :cascade do |t|
    t.float    "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eths", force: :cascade do |t|
    t.float    "price"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questrades", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regressions", force: :cascade do |t|
    t.float    "slope"
    t.float    "rsquared"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "titres", force: :cascade do |t|
    t.string   "symbol"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trades", force: :cascade do |t|
    t.string   "symbol"
    t.float    "price"
    t.string   "action"
    t.float    "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
