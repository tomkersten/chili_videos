require File.dirname(__FILE__) + '/../test_helper'

class VideosControllerTest < ActionController::TestCase
  def setup
    @project = Project.generate!.reload
    @user = User.generate!
    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))

    # "log in" the user
    @request.session[:user_id] = @user.id
  end

  context 'Viewing the videos available to a project' do
    setup do
      @request.session[:user_id] = @user.id
    end

    context "when the plugin has not been set up" do
      setup do
        ChiliVideoPlugin::Config.update(:api_key => '', :workflow => '')
      end

      should "renders the 'plugin not set up' page" do
        get :index, :project_id => @project.to_param
        assert_template 'plugin_not_configured'
      end
    end
  end

  context 'Adding a new video' do
    context "when the plugin has been set up" do
      setup do
        ChiliVideoPlugin::Config.update(:api_key => 'key', :workflow => 'workflow')
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
        ChiliVideoPlugin::Config.update(:api_key => '', :workflow => '')
      end

      should "renders the 'plugin not set up' page" do
        get :new, :project_id => @project.to_param
        assert_template 'plugin_not_configured'
      end
    end
  end

  context 'Handling requests from Transload.it' do
    should 'create a new Assembly' do
      Assembly.destroy_all
      get :upload_complete, {:project_id => @project.to_param}.merge(transloadit_payload)
      assert_equal 1, Assembly.count
    end
  end
end
