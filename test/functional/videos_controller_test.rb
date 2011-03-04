require File.dirname(__FILE__) + '/../test_helper'

class VideosControllerTest < ActionController::TestCase
  fixtures :projects

  context 'Adding a new video' do
    setup do
      @project = Project.generate!.reload
      @user = User.generate!(:firstname => 'Test', :lastname => 'one', :login => 'existing', :password => 'existing', :password_confirmation => 'existing')
      User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))

      @plugin_settings = {'transloadit_workflow' => 'workflow', 'transloadit_api_key' => 'key'}
      Setting['plugin_chili_videos'] = @plugin_settings

      @request.session[:user_id] = @user.id
    end

    should 'set up an @settings instance variable for the view template' do
      get :new, :project_id => @project.to_param
      assert_equal @plugin_settings, assigns(:settings)
    end
  end
end
