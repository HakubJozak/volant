require 'test_helper'

class RestfulControllerTest < ActionController::TestCase

  def setup
    @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64.encode64('admin:test')}"
  end

end
