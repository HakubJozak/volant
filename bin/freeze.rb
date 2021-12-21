DIR = '/tmp'


def backup(path, scope)
  sql = "COPY (#{scope.to_sql}) TO '#{DIR}/#{path}' DELIMITER ',' CSV HEADER;"
  puts sql
  ActiveRecord::Base.connection.execute(sql)
end

def backup_all
  # TODO: tags
  backup 'applications.csv',
         ApplyForm
           .select("apply_forms.*, workcamp_assignments.*, payments.*, string_agg(tags.name,';') AS tags")
           .left_joins(:tags)
           .left_joins(:workcamp_assignments)
           .left_joins(:payment)
           .group_by(1)

  backup 'volunteers.csv', Volunteer.all

  backup 'organizations.csv',
         Organization
           .left_joins(:networks)


  backup 'intentions.csv', WorkcampIntention
end


backup 'workcamps.csv',
       Workcamp
         .select("workcamps.*, string_agg(workcamp_intentions.code,';') AS intentions, string_agg(tags.name,';') AS tags")
         .left_joins(:tags)
         .left_joins(:intentions)
         .group('1')
         .order('workcamps.created_at')
