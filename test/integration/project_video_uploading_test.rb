require File.dirname(__FILE__) + '/../test_helper'

class ProjectVideoUploadingTest < ActionController::IntegrationTest
  def setup
    @user = User.generate!(:login => 'existing', :password => 'existing', :password_confirmation => 'existing')
    @project = Project.generate!.reload

    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))

    login_as
  end

  def plugin_settings(api_key, workflow)
    Setting["plugin_chili_videos"] = HashWithIndifferentAccess.new({:transloadit_api_key => api_key, :transloadit_workflow => workflow})
  end


  context "Uploading a video" do
    context "when the plugin is set up correctly" do
      setup do
        plugin_settings('api-key', 'workflow')
      end

      should "set the 'redirect_url' form param to the 'upload_complete' url" do
        visit(new_project_video_path(@project))
        proper_redirect_url = "&quot;redirect_url&quot;:&quot;http://www.example.com/projects/#{@project.to_param}/videos/upload_complete&quot;"
        assert_match proper_redirect_url, response.body
      end

      should "set the 'template_id' form param to the setting stored in the plugin settings" do
        visit(new_project_video_path(@project))
        escaped_template_id = "&quot;template_id&quot;:&quot;workflow&quot;"
        assert_match escaped_template_id, response.body
      end

      should "set the 'auth_key' form param to the setting stored in the plugin settings" do
        visit(new_project_video_path(@project))
        escaped_api_key = "&quot;key&quot;:&quot;api-key&quot;"
        assert_match escaped_api_key, response.body
      end
    end

    context "when the plugin does not have either the Transload.it workflow or API key stored in the plugin settings" do
      setup do
        plugin_settings('','')
      end

      should "display a message telling the user to set up the plugin on the plugin administration page" do
        visit(new_project_video_path(@project))
        within("p.warning") do
          assert_have_selector('a', :href => '/settings/plugin/chili_videos')
        end
      end
    end
  end
end
