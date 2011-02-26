require "test_helper"

module Outgoing
  class ApplyFormsControllerTest < ActionController::TestCase

    include ActiveScaffoldCRUDTester

    def setup
      super
      @paid = Factory.create(:paid_form)
      @male = Factory.create(:male)
      @request.env["HTTP_REFERER"] = 'BACK'
      DataLoader.load_emails
    end

    # def test_autocomplete_routing
    #   assert_routing '/payments/auto_complete_belongs_to_for_record_apply_form_name', 
    #                  :controller => 'outgoing/apply_forms', 
    #   :action => 'auto_complete_belongs_to_for_record_apply_form_name'
    # end

    def test_csv_export
      get :export
      assert_response :success
    end

    def test_vef
      get :vef, :id => Factory.create(:paid_form)
      assert_response :success
    end

    def test_acceptation_mail
      xhr :get, :accept, :id => @paid.id
      assert_response :success
    end

    def test_mail_witch_attachment
      post :ask,
      :id => @paid.id,
      :mail => {
        :from => 'me',
        :to => 'you',
        :subject => 'subject',
        :attachments => [ { :type => 'VefAttachment', :form_id => @paid.id } ]
      }

      assert_not_nil assigns(:mail)
      assert_equal VefAttachment, assigns(:mail).attachments[0].class
    end

    def test_alert_filter
      get :list, :state_filter => 'alerts', :year => Date.today.year
      assert_response :success 
    end

    def test_cancellation
      xhr :post, :cancel, :id => @paid.id
      assert_equal :cancelled, assigns(:record).state.name
      assert_redirected_to 'BACK'
    end

    def test_lifecycle
      test_state_change @paid, :ask
      test_state_change @paid, :accept
      test_state_change @paid, :infosheet
    end

    def test_rejection
      @paid.workcamps.clear
      Workcamp.find(:all, :limit => 3).each_with_index do |wc,i|
        @paid.workcamp_assignments << WorkcampAssignment.new( :order => i+1, :workcamp => wc )
      end

      test_state_change @paid, :ask, :asked
      test_state_change @paid, :reject, :asked
      test_state_change @paid, :reject, :asked
    end


    def test_date_parsing
      params = {"commit"=>"Upravit", "id" => ApplyForm.first.id,
        "record"=>{ "volunteer"=>{"id"=> @male.id}}}

      params["record"]["cancelled"] = "22.1.2009 15:37"
      post :update, params
      assert_equal DateTime.new(2009,1,22,15,37), assigns(:record).cancelled
    end

    protected

    def test_state_change(form, action, expected_state = nil)
      expected_state ||= "#{action}ed".intern

      xhr :post, action, :id => form.id
      assert_response :success

      xhr :post, assigns(:action),
      :id => form.id,
      :mail => { :to => "someone", :from => "someone else", :subject => 'something', :body => 'text' }

      assert_equal expected_state, assigns(:form).state.name
    end

    def item
      Factory.create(:paid_form)
    end

  end
end
