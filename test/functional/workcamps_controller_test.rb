require 'test_helper'

class WorkcampsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  def setup
    super
    @cz = Factory.create(:user, :login => "cz_user", :locale => 'cz')
    @en = Factory.create(:user, :login => "en_user", :locale => 'en')
  end

  test "alliance export" do
    get :export_alliance_xml
    assert_response :success
  end

  test "export routing" do
    [ 'incoming', 'outgoing' ].each do |prefix|
      assert_routing "/#{prefix}/workcamps/export_alliance_xml", :controller => "#{prefix}/workcamps", :action => 'export_alliance_xml'          
    end
  end
  
  test "czech date parsing" do
    users = [ [ @cz, '27.3.1982' , Date.new(1982,3,27) ],
              [ @en, '2011-05-30', Date.new(2011,5,30) ] ]     

      users.each do |user,str,result|
        login_as(user)
        post :create, :record => { :begin => str }, :id => item.id
        assert_response :success

        wc = assigns(:record)
        assert_not_nil wc

        assert_equal result, wc.begin
      end
  end

  protected

  def item
    Workcamp.find(:first)
  end

end
