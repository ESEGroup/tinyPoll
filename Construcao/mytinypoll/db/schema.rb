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

ActiveRecord::Schema.define(version: 20160802135132) do

  create_table "creator_permission_lists", force: :cascade do |t|
    t.integer "user_id", limit: 4
  end

  add_index "creator_permission_lists", ["user_id"], name: "index_creator_permission_lists_on_user_id", unique: true, using: :btree

  create_table "poll_answers", force: :cascade do |t|
    t.integer "poll_polls_id",                       limit: 4
    t.integer "poll_objective_objective_options_id", limit: 4
    t.string  "discursive_answer",                   limit: 255
    t.string  "type",                                limit: 255
  end

  create_table "poll_has_answereds", force: :cascade do |t|
    t.integer "user_id",       limit: 4
    t.integer "poll_polls_id", limit: 4
  end

  create_table "poll_invite_people", force: :cascade do |t|
    t.integer  "poll_polls_id", limit: 4
    t.string   "email",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "poll_objective_objective_options", force: :cascade do |t|
    t.integer "poll_polls_id", limit: 4
    t.string  "alternative",   limit: 255
  end

  create_table "poll_polls", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.string   "privacy",                  limit: 255
    t.string   "question",                 limit: 255
    t.datetime "deadline"
    t.string   "type",                     limit: 255
    t.integer  "user_id",                  limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "poll_avatar_file_name",    limit: 255
    t.string   "poll_avatar_content_type", limit: 255
    t.integer  "poll_avatar_file_size",    limit: 4
    t.datetime "poll_avatar_updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "cpf",                    limit: 255
    t.string   "fb_token",               limit: 255
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
