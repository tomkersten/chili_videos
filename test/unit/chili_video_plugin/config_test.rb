require File.dirname(__FILE__) + '/../../test_helper'

class ConfigTest < ActiveSupport::TestCase
  setup do
    Setting["plugin_chili_videos"] = HashWithIndifferentAccess.new({:transloadit_api_key => 'api_key', :transloadit_workflow => 'workflow_name'})
  end

    context '.api_key' do
      should "returns the value of the plugin's 'transloadit_api_key' setting" do
        assert_equal 'api_key', ChiliVideoPlugin::Config.api_key
      end
    end

    context '.workflow' do
      should "returns the value of the plugin's 'transloadit_workflow' setting" do
        assert_equal 'workflow_name', ChiliVideoPlugin::Config.workflow
      end
    end
end
