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

ActiveRecord::Schema.define(version: 20150622202617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "drugs", force: :cascade do |t|
    t.string   "dea_schedule"
    t.string   "description"
    t.integer  "labeler"
    t.string   "nonproprietary_name"
    t.integer  "package_code"
    t.string   "package_ndc"
    t.decimal  "price_per_unit",      precision: 15, scale: 5
    t.integer  "product_code"
    t.string   "product_ndc"
    t.string   "proprietary_name"
    t.string   "unit"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pharma_class_chemicals", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "class_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pharma_class_establisheds", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "class_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pharma_class_methods", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "class_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pharma_class_physiologics", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "class_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "type_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "routes", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "route"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "service_caches", force: :cascade do |t|
    t.string   "service"
    t.string   "key"
    t.hstore   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "substances", force: :cascade do |t|
    t.string   "product_ndc"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
