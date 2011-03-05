require File.dirname(__FILE__) + '/../test_helper'

class VideosControllerTest < ActionController::TestCase
  fixtures :projects

  context 'Adding a new video' do
    setup do
      @project = Project.generate!.reload
      @user = User.generate!(:firstname => 'Test', :lastname => 'one', :login => 'existing', :password => 'existing', :password_confirmation => 'existing')
      User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))

      @plugin_settings = {'transloadit_workflow' => 'workflow', 'transloadit_api_key' => 'key'}
      @request.session[:user_id] = @user.id
    end

    context "when the plugin has been set up" do
      setup do
        Setting['plugin_chili_videos'] = @plugin_settings
      end

      should "renders the upload form" do
        get :new, :project_id => @project.to_param
        assert_template 'new'
      end

      should 'set up an @api_key instance variable for the view template' do
        get :new, :project_id => @project.to_param
        assert_equal 'key', assigns(:api_key)
      end

      should 'set up an @workflow instance variable for the view template' do
        get :new, :project_id => @project.to_param
        assert_equal 'workflow', assigns(:workflow)
      end
    end

    context "when the plugin has not been set up" do
      setup do
        Setting['plugin_chili_videos'] = nil
      end

      should "renders the 'plugin not set up' page" do
        get :new, :project_id => @project.to_param
        assert_template 'plugin_not_configured'
      end
    end
  end
end
