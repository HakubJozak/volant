class MenuSweeper < ActionController::Caching::Sweeper
  observe Organization
  observe ColoredTag
  observe Tagging

  def after_save(record)
    expire_cache(record)
  end

  def after_destroy(record)
    expire_cache(record)
  end

  protected

  def expire_cache(record)
    MenuHelper.recent_years.each do |year|
      # TODO - dry up and synchronize with _menu.html.erb
      expire_fragment "#{year}-by-states-apply-forms-menu"
      expire_fragment "#{year}-by-tags-apply-forms-menu"
      expire_fragment "#{year}-by-tags-workcamps-menu"
      expire_fragment "#{year}-by-organizations-workcamps-menu" if Organization === record
    end
  end

end
