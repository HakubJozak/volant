class CommentsController < ApplicationController

  active_scaffold :comments do |config|
    config.columns = [ :user, :comment ]

    ban_editing(config, :user)
    config.columns[:user].clear_link
    config.actions.exclude :update, :show

    config.nested.label = 'comments'
    config.list.sorting = { :created_at => :desc }

    highlight_required config, Comment
  end

  def before_create_save(record)
    record.user = current_user
  end

end
