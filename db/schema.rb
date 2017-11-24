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

ActiveRecord::Schema.define(version: 20171124080631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dias", force: :cascade do |t|
    t.float "valor"
    t.bigint "meta_id"
    t.date "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meta_id"], name: "index_dias_on_meta_id"
  end

  create_table "dias_vendedores", id: false, force: :cascade do |t|
    t.bigint "vendedor_id", null: false
    t.bigint "dia_id", null: false
    t.index ["dia_id", "vendedor_id"], name: "index_dias_vendedores_on_dia_id_and_vendedor_id"
    t.index ["vendedor_id", "dia_id"], name: "index_dias_vendedores_on_vendedor_id_and_dia_id"
  end

  create_table "lojas", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "proprietario_id"
    t.index ["proprietario_id"], name: "index_lojas_on_proprietario_id"
  end

  create_table "metas", force: :cascade do |t|
    t.integer "mes"
    t.integer "ano"
    t.date "inicio"
    t.date "fim"
    t.float "valor"
    t.bigint "loja_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loja_id"], name: "index_metas_on_loja_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendedores", force: :cascade do |t|
    t.string "nome"
    t.bigint "loja_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loja_id"], name: "index_vendedores_on_loja_id"
  end

  add_foreign_key "dias", "metas"
  add_foreign_key "lojas", "users", column: "proprietario_id"
  add_foreign_key "metas", "lojas"
  add_foreign_key "vendedores", "lojas"
end
