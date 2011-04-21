require File.dirname(__FILE__) + '/../test_helper'

class VideosControllerTest < ActionController::TestCase
  def setup
    ChiliVideos::Config.update(:api_key => 'key', :workflow => 'workflow')
    @project = Project.generate!.reload
    @user = User.generate!
    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video, :view_specific_video, :delete_video]))

    # "log in" the user
    @request.session[:user_id] = @user.id
  end

  context 'Viewing the videos available to a project' do
    context "when the plugin has not been set up" do
      setup do
        ChiliVideos::Config.update(:api_key => '', :workflow => '')
      end

      should "renders the 'plugin not set up' page" do
        get :index, :project_id => @project.to_param
        assert_template 'plugin_not_configured'
      end
    end

    context "when the plugin has been set up" do
      context "and there are unprocessed assemblies" do
        setup do
          Assembly.generate!(:processed => false, :project_id => @project.id)
        end

        should "set a notification message for the view template" do
          get :index, :project_id => @project.to_param
          assert_not_nil flash[:notice]
        end
      end

      context "and all assemblies have been processed" do
        setup do
          Assembly.destroy_all
        end

        should "does not set a notification message for the view template" do
          get :index, :project_id => @project.to_param
          assert_nil flash[:notice]
        end
      end
    end
  end

  context 'Adding a new video' do
    context "when the plugin has been set up" do
      setup do
        ChiliVideos::Config.update(:api_key => 'key', :workflow => 'workflow')
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

      should 'set up a @versions instance variable for the view template' do
        version = Version.generate!(:project_id => @project.id)
        get :new, :project_id => @project.to_param
        assert_equal [version], assigns(:versions)
      end
    end

    context "when the plugin has not been set up" do
      setup do
        ChiliVideos::Config.update(:api_key => '', :workflow => '')
      end

      should "renders the 'plugin not set up' page" do
        get :new, :project_id => @project.to_param
        assert_template 'plugin_not_configured'
      end
    end
  end

  context 'Handling requests from Transload.it' do
    setup do
      Assembly.destroy_all
      stub_assembly_url
    end

    should 'create a new Assembly' do
      get :upload_complete, workflow_results.merge({'project_id' => @project.to_param})
      assert_equal 1, Assembly.count
    end

    should 'assigns the assembly to the logged in user' do
      get :upload_complete, workflow_results.merge({'project_id' => @project.to_param})
      assert_equal @user.id, Assembly.first.user_id
    end
  end

  context "Viewing a specific video associated with a Project" do
    context "when no videos have been associated with the project" do
      setup do
        Video.destroy_all
        get :show, :project_id => @project.to_param, :id => 'nonexistant-video'
      end

      should "redirect back to the list of project videos" do
        assert_redirected_to(project_videos_path(:project_id => @project.to_param))
      end

      should "display an error message to the user" do
        assert_not_nil flash[:error]
      end
    end

    context "when videos have been associated with the project" do
      setup do
        @video = Video.create!(:title => "Video 1", :description => "Description...", :url => "http://some-url-here.com/", :project_id => @project.id, :user_id => @user.id)
        get :show, :project_id => @project.to_param, :id => @video.to_param
      end

      should "assign the requested video to @video for the view template" do
        assert_equal @video, assigns(:video)
      end

      should "assign the project associted with the requested video to @project for the view template" do
        assert_equal @project, assigns(:project)
      end
    end
  end

  context "Deleting a video" do
    setup do
      @video = Video.create!(:title => "Video 1", :description => "Description...", :url => "http://some-url-here.com/", :project_id => @project.id, :user_id => @user.id)
    end

    should "actually delete the video from the database" do
      delete :destroy, :project_id => @project.to_param, :id => @video.to_param
      assert_nil Video.find_by_id(@video.id)
    end

    should "redirect to the list of videos for the project" do
      delete :destroy, :project_id => @project.to_param, :id => @video.to_param
      assert_redirected_to project_videos_path(@project)
    end
  end
end
