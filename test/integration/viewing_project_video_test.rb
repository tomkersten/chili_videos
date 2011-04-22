require File.dirname(__FILE__) + '/../test_helper'

class ViewingProjectVideoTest < ActionController::IntegrationTest
  include VideosHelper

  def setup
    ChiliVideos::Config.update(:api_key => 'api-key', :workflow => 'wf')

    @user = User.generate!(:login => 'existing', :password => 'existing', :password_confirmation => 'existing', :admin => true)
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

      should "have a link to delete the video" do
        within("div.contextual") do
          assert_have_selector("a[class~='video-del'][href='#{project_video_path(@project, @video)}']")
        end
      end

      should "have a link to edit the video" do
        within("div.contextual") do
          assert_have_selector("a[class~='video-edit'][href='#{edit_project_video_path(@project, @video)}']")
        end
      end

      should "have a link to upload a new video" do
        within("div.contextual") do
          assert_have_selector("a", :href => new_project_video_path(@project))
        end
      end
    end
  end

  context "Deleting a video by clicking the 'delete video' link" do
    setup do
      @video = Video.create!(:title => "Video 1", :description => "Description...", :url => "http://some-url-here.com/", :project_id => @project.id, :user_id => @user.id)
      delete_via_redirect(project_video_path(@project, @video))
    end

    should "notify the user that the video was deleted" do
      assert_have_selector(".notice")
    end

    should "removes the video from the project's list of videos" do
      visit project_videos_path(@project)
      assert_have_no_selector(".video##{@video.to_param}")
    end
  end
end
