class CreateApplyFormsView < ViewMigration
  def self.up
    stmt =  %{SELECT
                application.*,
                workcamp_id as "current_workcamp_id",
                current_assignment_id as "current_assignment_id",
                accepted,
                rejected,
                asked,
                infosheeted
              FROM apply_forms AS application
              LEFT OUTER JOIN #{assignments_by_order}
              ON workcamp.apply_form_id = application.id}

    returning =  'apply_forms.*,0,0,'
    returning << 'NULL::timestamp as "apply_forms.accepted",'
    returning << 'NULL::timestamp as "apply_forms.rejected",'
    returning << 'NULL::timestamp as "apply_forms.asked",'
    returning << 'NULL::timestamp as "apply_forms.infosheeted"'

    columns = [ "volunteer_id", "fee", "cancelled", "general_remarks",
                "motivation", "created_at", "updated_at" ]
    create_view('apply_forms_view', 'apply_forms', columns, stmt,returning)
  end

  def self.down
    drop_view('apply_forms_view')
  end

  private

  def self.assignments_by_order
    %{(SELECT
          assignment.id as current_assignment_id,
          assignment.apply_form_id as apply_form_id,
          workcamp_id,
          accepted,
          rejected,
          asked,
          infosheeted
       FROM
          workcamp_assignments AS assignment
       INNER JOIN #{latest_assignments}
       ON
         (assignment.apply_form_id = latest.apply_form_id AND
          assignment.order = latest.order))
       AS workcamp}
  end


  def self.latest_assignments
    %{ (SELECT apply_form_id, min("order") as "order" FROM
        (SELECT * FROM pending_assignments
           UNION
         SELECT * FROM accepted_assignments
           UNION
         SELECT * FROM rejected_assignments)
       AS assignments
       GROUP BY apply_form_id) as latest
     }
  end

end


# -- Rule: "apply_forms_view_insert ON apply_forms_view"

# -- DROP RULE apply_forms_view_insert ON apply_forms_view;

# CREATE OR REPLACE RULE apply_forms_view_insert AS
#     ON INSERT TO apply_forms_view DO INSTEAD  INSERT INTO apply_forms (volunteer_id, cancelled, general_remarks, motivation, created_at, updated_at)
#   VALUES (new.volunteer_id, new.cancelled, new.general_remarks, new.motivation, new.created_at, new.updated_at)
#   RETURNING apply_forms.id, apply_forms.volunteer_id, apply_forms.cancelled, apply_forms.general_remarks, apply_forms.motivation, apply_forms.created_at, apply_forms.updated_at, 0, NULL::timestamp without time zone AS accepted, NULL::timestamp without time zone AS rejected, NULL::timestamp without time zone AS asked;


