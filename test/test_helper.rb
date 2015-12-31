ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # Minitest::Reporters::ProgressReporter.new

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  
  fixtures :all

  setup do
    Account.create!(organization: Organization.find_by_code('SDA'),
                    organization_response_limit: 4,
                    infosheet_waiting_limit: 30,
                    season_end: Date.new(2015,3,15))
    Factory.create(:organization, code:'SDA')
  end

  def assert_valid(record)
    assert record.valid?, "Record #{record.inspect} is invalid"
  end

  def assert_invalid( *params )
    record = params.shift

    if Array === params[0]
      invalid_fields = params[0]
    else
      invalid_fields = params
    end

    assert_equal false, record.valid?, "Record #{record} is supposed to be invalid"
    invalid_fields.each do |field|
      assert_not_nil record.errors[field], "#{field} in #{record} is expected to be invalid"
    end
  end


  def assert_not_empty(object)
    assert_equal false, object.empty?, "#{object} shouldn't be empty"
  end

  def json_response
    JSON.parse(response.body)
  end

  def json
    JSON.parse(response.body).deep_symbolize_keys
  end

  # First parameter should be the object that
  # is supposed to validate presence of selected attributes.
  # Rest of the params are symbols representing those attributes.
  def assert_validates_presence_of(*params)
    object = params.shift
    attributes = params

    attributes.each do |attr|
      object.send("#{attr}=", nil)
    end

    assert_invalid object, attributes
  end

  # Asserts record of the given class and id doesn't exist.
  def assert_not_found(clazz, id)
    message = "#{clazz} with ID #{id} is still here!"
    assert_raise ActiveRecord::RecordNotFound, message do
      clazz.find(id)
    end
  end

  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    if String === user
      id = users(user).id
    elsif User === user
      id = user.id
    end

    @request.session[:user_id] = id || nil
  end

  def logout
    @request.session[:user_id] = nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
