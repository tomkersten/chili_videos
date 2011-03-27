require File.dirname(__FILE__) + '/../test_helper'

class ViewingProjectVideoTest < ActionController::IntegrationTest
  include VideosHelper

  def setup
    ChiliVideoPlugin::Config.update(:api_key => 'api-key', :workflow => 'wf')

    @user = User.generate!(:login => 'existing', :password => 'existing', :password_confirmation => 'existing')
    @project = Project.generate!.reload
    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video, :view_specific_video]))
    login_as
  end

  context "Viewing a specific video associated with a Project by clicking the video link" do
    context "when the specified video is not associated with the project" do
      setup do
        Video.destroy_all
        visit(project_video_path(@project, 'nonexistant-video'))
      end

      should "display an error message to the user" do
        assert_have_selector("div.error")
      end
    end

    context "when the requested video has been associated with the project" do
      setup do
        @video = Video.create!(:title => "Video 1", :description => "Description...", :url => "http://some-url-here.com/", :project_id => @project.id, :user_id => @user.id)
        visit(project_video_path(@project, @video))
      end

      should "include the code to embed the video in another project page with the standard size" do
        within("div.video") do
          assert_have_selector("input.embed.standard[value='#{video_embed_macro_markup(@video)}']")
        end
      end
    end
  end
end
