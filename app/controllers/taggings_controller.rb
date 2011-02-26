class TaggingsController < ApplicationController

    cache_sweeper :menu_sweeper

    active_scaffold :taggings do |config|
      config.columns = [ :tag ]
    end

end
