require 'db/migrate/20090214125123_create_apply_forms_view.rb'
require 'db/migrate/20090214125124_create_advanced_workcamp_view.rb'

class CacheAssignment < ViewMigration
  def self.up
    CreateAdvancedWorkcampView.down
    CreateApplyFormsView.down
    add_column :apply_forms, :current_workcamp_id_cached, :integer
    add_column :apply_forms, :current_assignment_id_cached, :integer
    CreateApplyFormsView.up
    CreateAdvancedWorkcampView.up

    stmt =  %{SELECT
                application.*,
                accepted,
                rejected,
                asked,
                infosheeted
              FROM apply_forms AS application
              LEFT OUTER JOIN workcamp_assignments
              ON application.current_assignment_id_cached = workcamp_assignments.id }

    returning =  'apply_forms.*,'
    returning << 'NULL::timestamp as "apply_forms.accepted",'
    returning << 'NULL::timestamp as "apply_forms.rejected",'
    returning << 'NULL::timestamp as "apply_forms.asked",'
    returning << 'NULL::timestamp as "apply_forms.infosheeted"'

    columns = [  "volunteer_id", "fee", "cancelled", "general_remarks",
                  "motivation", "created_at", "updated_at",
                  "current_workcamp_id_cached", "current_assignment_id_cached" ]

    create_view('apply_forms_cached_view', 'apply_forms', columns, stmt,returning)
  end

  def self.down
    drop_view('apply_forms_cached_view')
    CreateAdvancedWorkcampView.down
    CreateApplyFormsView.down
    remove_column :apply_forms, :current_workcamp_id_cached
    remove_column :apply_forms, :current_assignment_id_cached
    CreateApplyFormsView.up
    CreateAdvancedWorkcampView.up
  end
end
