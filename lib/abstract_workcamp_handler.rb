class AbstractWorkcampHandler

  include XmlHelper
  include InexRules

  protected

  # Checks whether the workcamp defined by supplied XML node exists in the database.
  # Returns the first found workcamp or nil.
  def existing?(node)
    name = to_text(node, 'name')
    code = to_text(node, 'code')
    from = to_date(node, 'start_date')
    to = to_date(node, 'end_date')

    params = { :code => code, :name => name, :begin => from, :end => to }
    Workcamp.find( :first, :conditions => params)
  end

end
