# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100204103640) do

  create_table "apply_forms", :force => true do |t|
    t.integer  "volunteer_id"
    t.decimal  "fee",                          :precision => 10, :scale => 2, :default => 2200.0,                :null => false
    t.datetime "cancelled"
    t.text     "general_remarks"
    t.text     "motivation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_workcamp_id_cached"
    t.integer  "current_assignment_id_cached"
    t.string   "type",                                                        :default => "Outgoing::ApplyForm", :null => false
    t.datetime "confirmed"
  end

  add_index "apply_forms", ["id"], :name => "index_apply_forms_on_id"

  create_table "bookings", :force => true do |t|
    t.integer  "workcamp_id"
    t.integer  "organization_id"
    t.integer  "country_id"
    t.string   "gender",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "countries", :force => true do |t|
    t.string   "code",        :limit => 2, :null => false
    t.string   "name_cs"
    t.string   "name_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "triple_code", :limit => 3
  end

  create_table "email_contacts", :force => true do |t|
    t.boolean  "active",          :default => false
    t.string   "address",                            :null => false
    t.string   "name"
    t.string   "notes"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "action"
    t.string   "description"
    t.string   "subject"
    t.string   "wrap_into_template", :default => "mail"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostings", :force => true do |t|
    t.integer  "workcamp_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_changes", :force => true do |t|
    t.string   "field",       :null => false
    t.text     "value",       :null => false
    t.text     "diff"
    t.integer  "workcamp_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infosheets", :force => true do |t|
    t.integer  "workcamp_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  add_index "infosheets", ["workcamp_id"], :name => "index_infosheets_on_workcamp_id"

  create_table "languages", :force => true do |t|
    t.string   "code",        :limit => 2
    t.string   "triple_code", :limit => 3, :null => false
    t.string   "name_cs"
    t.string   "name_en",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leaderships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "workcamp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "web"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "country_id",                     :null => false
    t.string   "name",                           :null => false
    t.string   "code",                           :null => false
    t.string   "address"
    t.string   "contact_person"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "website",        :limit => 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["id"], :name => "index_organizations_on_id"

  create_table "partners", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "contact_person"
    t.string   "phone"
    t.string   "email"
    t.string   "address",            :limit => 2048
    t.string   "website",            :limit => 2048
    t.string   "negotiations_notes", :limit => 5096
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partnerships", :force => true do |t|
    t.string   "description"
    t.integer  "network_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer "apply_form_id"
    t.decimal "amount",                          :precision => 10, :scale => 2, :null => false
    t.date    "received",                                                       :null => false
    t.string  "description",     :limit => 1024
    t.string  "account"
    t.string  "mean",                                                           :null => false
    t.date    "returned_date"
    t.decimal "returned_amount",                 :precision => 10, :scale => 2
    t.string  "return_reason",   :limit => 1024
    t.string  "bank_code",       :limit => 4
    t.string  "spec_symbol"
    t.string  "var_symbol"
    t.string  "const_symbol"
    t.string  "name"
  end

  create_table "people", :force => true do |t|
    t.string   "firstname",                                :null => false
    t.string   "lastname",                                 :null => false
    t.string   "gender",                                   :null => false
    t.integer  "old_schema_key"
    t.string   "email"
    t.string   "phone"
    t.date     "birthdate"
    t.string   "birthnumber"
    t.string   "nationality"
    t.string   "occupation"
    t.string   "account"
    t.string   "emergency_name"
    t.string   "emergency_day"
    t.string   "emergency_night"
    t.string   "speak_well"
    t.string   "speak_some"
    t.text     "special_needs"
    t.text     "past_experience"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fax"
    t.string   "street"
    t.string   "city"
    t.string   "zipcode"
    t.string   "contact_street"
    t.string   "contact_city"
    t.string   "contact_zipcode"
    t.string   "birthplace"
    t.string   "type",            :default => "Volunteer", :null => false
    t.integer  "workcamp_id"
    t.integer  "country_id"
    t.text     "note"
    t.integer  "organization_id"
  end

  add_index "people", ["id"], :name => "index_volunteers_on_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name",                                           :null => false
    t.string "color",      :limit => 7, :default => "#FF0000", :null => false
    t.string "text_color", :limit => 7, :default => "#FFFFFF", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                     :null => false
    t.string   "email",                                                     :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "locale",                    :limit => 3,  :default => "en", :null => false
  end

  create_table "workcamp_assignments", :force => true do |t|
    t.integer  "apply_form_id"
    t.integer  "workcamp_id"
    t.integer  "order",         :null => false
    t.datetime "accepted"
    t.datetime "rejected"
    t.datetime "asked"
    t.datetime "infosheeted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workcamp_assignments", ["accepted"], :name => "index_workcamp_assignments_on_accepted"
  add_index "workcamp_assignments", ["apply_form_id"], :name => "index_workcamp_assignments_on_apply_form_id"
  add_index "workcamp_assignments", ["asked"], :name => "index_workcamp_assignments_on_asked"
  add_index "workcamp_assignments", ["id"], :name => "index_workcamp_assignments_on_id"
  add_index "workcamp_assignments", ["infosheeted"], :name => "index_workcamp_assignments_on_infosheeted"
  add_index "workcamp_assignments", ["rejected"], :name => "index_workcamp_assignments_on_rejected"
  add_index "workcamp_assignments", ["workcamp_id"], :name => "index_workcamp_assignments_on_workcamp_id"

  create_table "workcamp_intentions", :force => true do |t|
    t.string   "code",           :null => false
    t.string   "description_cs", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description_en"
  end

  create_table "workcamp_intentions_workcamps", :id => false, :force => true do |t|
    t.integer "workcamp_id"
    t.integer "workcamp_intention_id"
  end

  create_table "workcamps", :force => true do |t|
    t.string   "code",                                                                                      :null => false
    t.string   "name",                                                                                      :null => false
    t.integer  "old_schema_key"
    t.integer  "country_id",                                                                                :null => false
    t.integer  "organization_id",                                                                           :null => false
    t.string   "language"
    t.date     "begin"
    t.date     "end"
    t.integer  "capacity"
    t.integer  "places",                                                                                    :null => false
    t.integer  "places_for_males",                                                                          :null => false
    t.integer  "places_for_females",                                                                        :null => false
    t.integer  "minimal_age",                                             :default => 18
    t.integer  "maximal_age",                                             :default => 99
    t.text     "area"
    t.text     "accomodation"
    t.text     "workdesc"
    t.text     "notes"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "extra_fee",                :precision => 10, :scale => 2
    t.string   "extra_fee_currency"
    t.string   "region"
    t.integer  "capacity_natives"
    t.integer  "capacity_teenagers"
    t.integer  "capacity_males"
    t.integer  "capacity_females"
    t.string   "airport"
    t.string   "train"
    t.string   "publish_mode",                                            :default => "ALWAYS",             :null => false
    t.integer  "accepted_places",                                         :default => 0,                    :null => false
    t.integer  "accepted_places_males",                                   :default => 0,                    :null => false
    t.integer  "accepted_places_females",                                 :default => 0,                    :null => false
    t.integer  "asked_for_places",                                        :default => 0,                    :null => false
    t.integer  "asked_for_places_males",                                  :default => 0,                    :null => false
    t.integer  "asked_for_places_females",                                :default => 0,                    :null => false
    t.integer  "free_places",                                             :default => 0,                    :null => false
    t.integer  "free_places_for_males",                                   :default => 0,                    :null => false
    t.integer  "free_places_for_females" ,                                :default => 0,                    :null => false
    t.string   "type",                                                    :default => "Outgoing::Workcamp", :null => false
    t.string   "sci_code"
    t.decimal  "longitude",                :precision => 11, :scale => 7
    t.decimal  "latitude",                 :precision => 11, :scale => 7
    t.string   "state"
    t.integer  "sci_id"
    t.text     "requirements"
  end

  add_index "workcamps", ["begin"], :name => "index_workcamps_on_begin"
  add_index "workcamps", ["country_id", "begin"], :name => "index_workcamps_on_country_id_and_begin"
  add_index "workcamps", ["id"], :name => "index_workcamps_on_id"
  add_index "workcamps", ["state"], :name => "index_workcamps_on_state"
  add_index "workcamps", ["state", "type"], :name => "index_workcamps_on_state_and_type"
  add_index "workcamps", ["state", "type", "begin"], :name => "index_workcamps_on_state_and_type_and_begin"
  add_index "workcamps", ["type"], :name => "index_workcamps_on_type"

  add_foreign_key "apply_forms", ["volunteer_id"], "people", ["id"], :name => "apply_forms_volunteer_id_fkey"

  add_foreign_key "bookings", ["workcamp_id"], "workcamps", ["id"], :name => "bookings_workcamp_id_fkey"
  add_foreign_key "bookings", ["organization_id"], "organizations", ["id"], :name => "bookings_organization_id_fkey"
  add_foreign_key "bookings", ["country_id"], "countries", ["id"], :name => "bookings_country_id_fkey"

  add_foreign_key "comments", ["user_id"], "users", ["id"], :name => "comments_user_id_fkey"

  add_foreign_key "email_contacts", ["organization_id"], "organizations", ["id"], :name => "email_contacts_organization_id_fkey"

  add_foreign_key "hostings", ["workcamp_id"], "workcamps", ["id"], :name => "hostings_workcamp_id_fkey"
  add_foreign_key "hostings", ["partner_id"], "partners", ["id"], :name => "hostings_partner_id_fkey"

  add_foreign_key "import_changes", ["workcamp_id"], "workcamps", ["id"], :name => "import_changes_workcamp_id_fkey"

  add_foreign_key "infosheets", ["workcamp_id"], "workcamps", ["id"], :name => "infosheets_workcamp_id_fkey"

  add_foreign_key "leaderships", ["person_id"], "people", ["id"], :name => "leaderships_person_id_fkey"
  add_foreign_key "leaderships", ["workcamp_id"], "workcamps", ["id"], :name => "leaderships_workcamp_id_fkey"

  add_foreign_key "organizations", ["country_id"], "countries", ["id"], :name => "organizations_country_id_fkey"

  add_foreign_key "partnerships", ["network_id"], "networks", ["id"], :name => "partnerships_network_id_fkey"
  add_foreign_key "partnerships", ["organization_id"], "organizations", ["id"], :name => "partnerships_organization_id_fkey"

  add_foreign_key "payments", ["apply_form_id"], "apply_forms", ["id"], :name => "payments_apply_form_id_fkey"

  add_foreign_key "people", ["workcamp_id"], "workcamps", ["id"], :name => "people_workcamp_id_fkey"
  add_foreign_key "people", ["country_id"], "countries", ["id"], :name => "people_country_id_fkey"
  add_foreign_key "people", ["organization_id"], "organizations", ["id"], :name => "people_organization_id_fkey"

  add_foreign_key "taggings", ["tag_id"], "tags", ["id"], :name => "taggings_tag_id_fkey"

  add_foreign_key "workcamp_assignments", ["apply_form_id"], "apply_forms", ["id"], :name => "workcamp_assignments_apply_form_id_fkey"
  add_foreign_key "workcamp_assignments", ["workcamp_id"], "workcamps", ["id"], :name => "workcamp_assignments_workcamp_id_fkey"

  add_foreign_key "workcamp_intentions_workcamps", ["workcamp_id"], "workcamps", ["id"], :name => "workcamp_intentions_workcamps_workcamp_id_fkey"
  add_foreign_key "workcamp_intentions_workcamps", ["workcamp_intention_id"], "workcamp_intentions", ["id"], :name => "workcamp_intentions_workcamps_workcamp_intention_id_fkey"

  add_foreign_key "workcamps", ["country_id"], "countries", ["id"], :name => "workcamps_country_id_fkey"
  add_foreign_key "workcamps", ["organization_id"], "organizations", ["id"], :name => "workcamps_organization_id_fkey"

  create_view "pending_assignments", "SELECT a.apply_form_id, min(a.\"order\") AS \"order\" FROM workcamp_assignments a WHERE ((((a.accepted IS NULL) AND (a.asked IS NULL)) AND (a.rejected IS NULL)) OR ((a.asked IS NOT NULL) AND (a.rejected IS NULL))) GROUP BY a.apply_form_id;"
  create_view "accepted_assignments", "SELECT a.apply_form_id, min(a.\"order\") AS \"order\" FROM workcamp_assignments a WHERE ((a.accepted IS NOT NULL) AND (a.rejected IS NULL)) GROUP BY a.apply_form_id;"
  create_view "apply_forms_view", "SELECT application.id, application.volunteer_id, application.fee, application.cancelled, application.general_remarks, application.motivation, application.created_at, application.updated_at, application.current_workcamp_id_cached, application.current_assignment_id_cached, workcamp.workcamp_id AS current_workcamp_id, workcamp.current_assignment_id, workcamp.accepted, workcamp.rejected, workcamp.asked, workcamp.infosheeted FROM (apply_forms application LEFT JOIN (SELECT assignment.id AS current_assignment_id, assignment.apply_form_id, assignment.workcamp_id, assignment.accepted, assignment.rejected, assignment.asked, assignment.infosheeted FROM (workcamp_assignments assignment JOIN (SELECT assignments.apply_form_id, min(assignments.\"order\") AS \"order\" FROM ((SELECT pending_assignments.apply_form_id, pending_assignments.\"order\" FROM pending_assignments UNION SELECT accepted_assignments.apply_form_id, accepted_assignments.\"order\" FROM accepted_assignments) UNION SELECT rejected_assignments.apply_form_id, rejected_assignments.\"order\" FROM rejected_assignments) assignments GROUP BY assignments.apply_form_id) latest ON (((assignment.apply_form_id = latest.apply_form_id) AND (assignment.\"order\" = latest.\"order\"))))) workcamp ON ((workcamp.apply_form_id = application.id)));"
  create_view "rejected_assignments", "SELECT a.apply_form_id, a.\"order\" FROM (workcamp_assignments a JOIN (SELECT c.apply_form_id, max(c.\"order\") AS maximum FROM workcamp_assignments c GROUP BY c.apply_form_id) b USING (apply_form_id)) WHERE ((a.\"order\" = b.maximum) AND (a.rejected IS NOT NULL));"
  create_view "active_countries_view", "SELECT DISTINCT c.id, c.code, c.name_cs, c.name_en, c.created_at, c.updated_at, c.triple_code FROM (countries c JOIN workcamps w ON ((c.id = w.country_id)));"
  create_view "apply_forms_cached_view", "SELECT application.id, application.volunteer_id, application.fee, application.cancelled, application.general_remarks, application.motivation, application.created_at, application.updated_at, application.current_workcamp_id_cached, application.current_assignment_id_cached, workcamp_assignments.accepted, workcamp_assignments.rejected, workcamp_assignments.asked, workcamp_assignments.infosheeted FROM (apply_forms application LEFT JOIN workcamp_assignments ON ((application.current_assignment_id_cached = workcamp_assignments.id)));"

end
