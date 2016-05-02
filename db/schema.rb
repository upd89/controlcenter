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

ActiveRecord::Schema.define(version: 20160430151923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "concrete_package_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concrete_package_versions", force: :cascade do |t|
    t.integer  "system_id"
    t.integer  "task_id"
    t.integer  "concrete_package_state_id"
    t.integer  "package_version_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "concrete_package_versions", ["concrete_package_state_id"], name: "index_concrete_package_versions_on_concrete_package_state_id", using: :btree
  add_index "concrete_package_versions", ["package_version_id"], name: "index_concrete_package_versions_on_package_version_id", using: :btree
  add_index "concrete_package_versions", ["system_id"], name: "index_concrete_package_versions_on_system_id", using: :btree
  add_index "concrete_package_versions", ["task_id"], name: "index_concrete_package_versions_on_task_id", using: :btree

  create_table "distributions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_assignments", force: :cascade do |t|
    t.integer  "package_group_id"
    t.integer  "package_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "group_assignments", ["package_group_id"], name: "index_group_assignments_on_package_group_id", using: :btree
  add_index "group_assignments", ["package_id"], name: "index_group_assignments_on_package_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.datetime "started_at"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "package_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "permission_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "package_installations", force: :cascade do |t|
    t.string   "installed_version"
    t.integer  "package_id"
    t.integer  "system_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "package_installations", ["package_id"], name: "index_package_installations_on_package_id", using: :btree
  add_index "package_installations", ["system_id"], name: "index_package_installations_on_system_id", using: :btree

  create_table "package_updates", force: :cascade do |t|
    t.string   "candidate_version"
    t.string   "repository"
    t.integer  "package_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "package_updates", ["package_id"], name: "index_package_updates_on_package_id", using: :btree

  create_table "package_versions", force: :cascade do |t|
    t.string   "sha256"
    t.string   "version"
    t.string   "architecture"
    t.integer  "package_id"
    t.integer  "distribution_id"
    t.integer  "repository_id"
    t.boolean  "is_base_version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "package_versions", ["distribution_id"], name: "index_package_versions_on_distribution_id", using: :btree
  add_index "package_versions", ["package_id"], name: "index_package_versions_on_package_id", using: :btree
  add_index "package_versions", ["repository_id"], name: "index_package_versions_on_repository_id", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "name"
    t.string   "base_version"
    t.string   "architecture"
    t.string   "section"
    t.string   "repository"
    t.string   "homepage"
    t.string   "summary"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "origin"
    t.string   "archive"
    t.string   "component"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "permission_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "system_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "permission_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "system_update_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_updates", force: :cascade do |t|
    t.integer  "system_update_state_id"
    t.integer  "package_update_id"
    t.integer  "system_id"
    t.integer  "task_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "system_updates", ["package_update_id"], name: "index_system_updates_on_package_update_id", using: :btree
  add_index "system_updates", ["system_id"], name: "index_system_updates_on_system_id", using: :btree
  add_index "system_updates", ["system_update_state_id"], name: "index_system_updates_on_system_update_state_id", using: :btree
  add_index "system_updates", ["task_id"], name: "index_system_updates_on_task_id", using: :btree

  create_table "systems", force: :cascade do |t|
    t.string   "name"
    t.string   "urn"
    t.string   "os"
    t.boolean  "reboot_required"
    t.string   "address"
    t.datetime "last_seen"
    t.integer  "system_group_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "systems", ["system_group_id"], name: "index_systems_on_system_group_id", using: :btree

  create_table "task_executions", force: :cascade do |t|
    t.string   "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "task_state_id"
    t.integer  "task_execution_id"
    t.integer  "job_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "system_update_id"
  end

  add_index "tasks", ["job_id"], name: "index_tasks_on_job_id", using: :btree
  add_index "tasks", ["task_execution_id"], name: "index_tasks_on_task_execution_id", using: :btree
  add_index "tasks", ["task_state_id"], name: "index_tasks_on_task_state_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "concrete_package_versions", "concrete_package_states"
  add_foreign_key "concrete_package_versions", "package_versions"
  add_foreign_key "concrete_package_versions", "systems"
  add_foreign_key "concrete_package_versions", "tasks"
  add_foreign_key "group_assignments", "package_groups"
  add_foreign_key "group_assignments", "packages"
  add_foreign_key "jobs", "users"
  add_foreign_key "package_installations", "packages"
  add_foreign_key "package_installations", "systems"
  add_foreign_key "package_updates", "packages"
  add_foreign_key "package_versions", "distributions"
  add_foreign_key "package_versions", "packages"
  add_foreign_key "package_versions", "repositories"
  add_foreign_key "system_updates", "package_updates"
  add_foreign_key "system_updates", "system_update_states"
  add_foreign_key "system_updates", "systems"
  add_foreign_key "system_updates", "tasks"
  add_foreign_key "systems", "system_groups"
  add_foreign_key "tasks", "jobs"
  add_foreign_key "tasks", "system_updates"
  add_foreign_key "tasks", "task_executions"
  add_foreign_key "tasks", "task_states"
  add_foreign_key "users", "roles"
end
