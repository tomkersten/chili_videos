require File.dirname(__FILE__) + '/../test_helper'

class ProjectVideoListTest < ActionController::IntegrationTest
  def setup
    @user = User.generate!(:firstname => 'Test', :lastname => 'one', :login => 'existing', :password => 'existing', :password_confirmation => 'existing')
    @project = Project.generate!.reload
    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))
    login_as
  end

  context "Clicking the 'Videos' tab on a Project page" do
    setup do
      visit_project(@project)
      click_link("Videos")
    end

    # TODO: Is there a way to make the menu use named routes?
    should "take you to the project's list of videos" do
      assert_equal project_videos_path(@project), current_path
    end

    should "display a link to add a new video to the project in the contextual menu" do
      within("div.contextual") do
        assert_have_selector("a", :href => new_project_video_path(@project))
      end
    end
  end

  context "Viewing the list of uploaded videos associated with a Project" do
    context "when no videos have been associated with the project" do
      setup do
        Video.destroy_all
        visit(project_videos_path(@project))
      end

      should "display a 'no videos' message" do
        assert_have_selector('p.nodata')
      end

      should "display a link to upload one in the 'no videos' message area" do
        within('p.nodata') do
          assert_have_selector('a', :href => new_project_video_path(@project))
        end
      end

      should "not have a list of videos" do
        assert_have_no_selector('ul.videos')
      end
    end

    context "when videos have been associated with the project" do
      setup do
        Video.create!(:name => "Video 1", :description => "Description...", :url => "http://some-url-here.com/", :project_id => @project.id)
        visit(project_videos_path(@project))
      end

      should "show a list of videos" do
        within("ul.videos") do
          assert_have_selector("li")
        end
      end

      should "not display a 'no videos' message" do
        assert_have_no_selector('p.nodata')
      end
    end
  end
end
