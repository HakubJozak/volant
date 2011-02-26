class CreateActiveCountriesView < ViewMigration
  def self.up
    sql = "SELECT DISTINCT c.* FROM countries c INNER JOIN workcamps w ON c.id = w.country_id"
    execute "CREATE VIEW active_countries_view AS #{sql}"
  end

  def self.down
    drop_view('active_countries_view')
  end
end
