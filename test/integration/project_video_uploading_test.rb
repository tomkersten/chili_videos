require File.dirname(__FILE__) + '/../test_helper'

class ProjectVideoUploadingTest < ActionController::IntegrationTest
  def setup
    @credentials = HashWithIndifferentAccess.new(:transloadit_api_key => 'api-key', :transloadit_workflow => 'workflow')

    @user = User.generate!(:firstname => 'Test', :lastname => 'one', :login => 'existing', :password => 'existing', :password_confirmation => 'existing')
    @project = Project.generate!.reload
    User.add_to_project(@user, @project, Role.generate!(:permissions => [:view_video_list, :add_video]))

    login_as
  end

  context "Uploading a video" do
    setup do
      Setting.create!(:name => "plugin_chili_videos", :value => @credentials)
      visit(new_project_video_path(@project))
    end

    context "when the plugin is set up correctly" do
      should "set the 'redirect_url' form param to the 'upload_complete' url" do
        proper_redirect_url = "&quot;redirect_url&quot;:&quot;http://www.example.com/projects/#{@project.to_param}/videos/upload_complete&quot;"
        assert_match proper_redirect_url, response.body
      end

      should "set the 'template_id' form param to the setting stored on the plugin url" do
        escaped_template_id = "&quot;template_id&quot;:&quot;workflow&quot;"
        assert_match escaped_template_id, response.body
      end

      should "set the 'auth_key' form param to the setting stored on the plugin url" do
        escaped_api_key = "&quot;key&quot;:&quot;api-key&quot;"
        assert_match escaped_api_key, response.body
      end
    end

    context "when the plugin does not have either the Transload.it workflow or API key stored in the plugin settings" do
      setup do
        Setting.find_by_name("plugin_chili_videos").destroy
        visit(new_project_video_path(@project))
      end

      #should "display a message telling the user to set up the plugin on the plugin administration page" do
      #  within("p.nodata") do
      #    assert_have_selector('a', :href => admin_plugin_path('chili_videos'))
      #  end
      #end
    end
  end
end
