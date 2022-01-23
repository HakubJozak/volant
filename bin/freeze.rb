# DIR = '/tmp'
DIR = "#{__dir__}/../freeze"


def backup(path, scope)
  sql = "COPY (#{scope.to_sql}) TO '#{DIR}/#{path}' WITH (FORMAT CSV,DELIMITER ',',ENCODING 'UTF-8',HEADER true);"
  puts sql
  ActiveRecord::Base.connection.execute(sql)
end

def backup_applications
  wc_codes = "string_agg(workcamps.CODE::text  ,';') AS Workcamps"
  wc_ids = "string_agg(workcamps.ID::text  ,';') AS WorkcampIDs"
  tags = "string_agg(tags.name,';') AS tags"

  backup 'applications.csv',
         ApplyForm
           .select("apply_forms.*,people.*,workcamp_assignments.*,workcamps.*")
           .joins(:volunteer)
           .left_joins(:tags)
           .left_joins(:workcamps)
           .left_joins(:payment)
           .group('1,2,3,4,people.id,workcamp_assignments.id,workcamps.id')
           .order('"apply_forms"."created_at"')
end

def backup_workcamps
  backup 'workcamps.csv',
         Workcamp
           .select("workcamps.*, string_agg(workcamp_intentions.code,';') AS intentions, string_agg(tags.name,';') AS tags")
           .left_joins(:tags)
           .left_joins(:intentions)
           .group('1')
           .order('workcamps.created_at')
end


def backup_all
  backup_applications

  backup_workcamps

  backup 'volunteers.csv', Volunteer.all

  backup 'organizations.csv',
         Organization
           .left_joins(:networks)


  backup 'intentions.csv', WorkcampIntention.all



  backup 'email_templates.csv', EmailTemplate.all
end

backup_all

# backup_workcamps

# backup_applications
