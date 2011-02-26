class AssignmentsView < ActiveRecord::Migration
  def self.up
    execute "CREATE VIEW pending_assignments AS #{probably_pending_select}"
    execute "CREATE VIEW accepted_assignments AS #{accepted_select}"
    execute "CREATE VIEW rejected_assignments AS #{rejected_select}"
  end

  def self.down
    drop_view "pending_assignments"
    drop_view "accepted_assignments"
    drop_view "rejected_assignments"
  end

  protected

  def self.probably_pending_select
    %{ SELECT
         a.apply_form_id, min(a."order") AS "order"
       FROM
          workcamp_assignments a
       WHERE
         (a.accepted IS NULL AND a.asked IS NULL AND a.rejected IS NULL)
       OR
         (a.asked IS NOT NULL AND a.rejected IS NULL)
       GROUP BY a.apply_form_id
      }
  end

  def self.accepted_select
    %{ SELECT
         a.apply_form_id, min(a."order") AS "order"
       FROM workcamp_assignments a
       WHERE
         a.accepted IS NOT NULL AND a.rejected IS NULL
       GROUP BY
         a.apply_form_id
      }
  end

  def self.rejected_select
    %{ SELECT
           a.apply_form_id, a."order" AS "order"
       FROM workcamp_assignments a
       JOIN (SELECT c.apply_form_id, max(c."order") AS maximum
             FROM workcamp_assignments c
             GROUP BY c.apply_form_id) b USING (apply_form_id)
             WHERE a."order" = b.maximum AND a.rejected IS NOT NULL
       }
  end

end
