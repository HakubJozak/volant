# From: https://github.com/discourse/discourse/commit/83679510006df74bd723e777478de23587d01831

module Middleware
  # this class cheats and bypasses rails altogether if the client attme
  class TurboDev
    def initialize(app, settings={})
      @app = app
    end
    def call(env)
      # hack to bypass all middleware if serving assets, a lot faster 4.5 seconds -> 1.5 seconds
      if (etag = env['HTTP_IF_NONE_MATCH']) && env['REQUEST_PATH'] =~ /^\/assets\//
        name = $'
        etag = etag.gsub "\"", ""
        asset = Rails.application.assets.find_asset(name)
        if asset && asset.digest == etag
          return [304,{},[]]
        end
      end

      @app.call(env)
    end
  end
end
