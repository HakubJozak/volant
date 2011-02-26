class RemoveAdvancedWorkcampView < ViewMigration
  def self.up
    drop_view("workcamps_view")
  end

  def self.down
    #raise ActiveRecord::IrreversibleMigration
  end
end
