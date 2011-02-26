class TagsController < ApplicationController

  cache_sweeper :menu_sweeper

  # TODO - use ColoredTag class instead?
  active_scaffold :tags do |config|
    config.list.sorting = { :name => 'ASC' }
    config.columns = [ :name, :color, :text_color ]
    config.list.columns = [ :tag_name ]
    highlight_required(config, Tag)
  end

  # Returns partial
  def list_tags

  end

end
