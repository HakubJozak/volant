# Provides support for simple filtering of models (ApplyForms or Workcamps) and also
# hacks the ActiveScaffold find_page method to avoid performance bug while joining
# with Payment table.
class FilteringController < ApplicationController

  protected

  def reset_filter
    @filter_sql = '(true) '
    @filter_params = []
    @title_suffixes = []
  end

  def tag_filter
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id].to_i)
      @filter_params << @tag.id
      @filter_sql << " AND (taggings.tag_id = ?) "
      @title_suffixes << " #{Tag.human_name.downcase} '#{@tag.name}'"
    end
  end

  def year_filter(date_field = 'created_at')
    if params[:year]
      @year = params[:year].to_i
      from = Date.new(@year,1,1)
      to = Date.new(@year + 1,1,1)
      @filter_params << from << to
      @filter_sql << " AND ((#{table_name}.#{date_field} >= ?) AND (#{table_name}.#{date_field} < ?)) "
      @title_suffixes << @year
    end
  end

  def table_name
    active_scaffold_config.model.table_name
  end

end
