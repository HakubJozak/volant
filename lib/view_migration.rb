class ViewMigration < ActiveRecord::Migration

  def self.create_view(name, table_name, model, definition, returning_clause)
    execute "CREATE VIEW #{name} AS #{definition}"

    if Class === model
      columns = model.columns.reject { |col| col.name == 'id' }.map { |c| c.name }
    elsif Array === model
      columns = model
    end

    names = columns.map { |col| "\"#{col}\"" }
    insert_values = names.map { |col| "new.#{col}" }.join(',')
    update_values = names.map { |col| "#{col} = new.#{col}" }.join(',')

    inserter =  "CREATE RULE #{name}_insert AS ON INSERT TO #{name} DO INSTEAD "
    inserter << " INSERT INTO #{table_name} (#{names.join(',')}) values (#{insert_values}) "
    inserter << " RETURNING #{returning_clause}"
    execute inserter

    updater =  "CREATE RULE #{name}_update AS ON UPDATE TO #{name} DO INSTEAD "
    updater << "UPDATE #{table_name} SET #{update_values}"
    updater << " WHERE id = old.id"
    execute updater

    deleter =  "CREATE RULE #{name}_delete AS ON DELETE TO #{name} DO INSTEAD "
    deleter  << "DELETE FROM #{table_name} WHERE id = old.id"
    execute deleter
  end


  def self.drop_view(name)
    execute "DROP VIEW #{name}"
  end

end
