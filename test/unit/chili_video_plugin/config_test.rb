require File.dirname(__FILE__) + '/../../test_helper'

include ChiliVideoPlugin

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

    context '.update' do
      context 'when all required parameters are supplied' do
        setup do
          @new_values = {:api_key => 'updated-api', :workflow => 'workflow-update'}
        end

        should "the value of the plugin's 'api_key' setting is updated" do
          assert_equal 'api_key', ChiliVideoPlugin::Config.api_key
          ChiliVideoPlugin::Config.update(@new_values)
          assert_equal @new_values[:api_key], ChiliVideoPlugin::Config.api_key
        end

        should "the value of the plugin's 'workflow-update'' setting is updated" do
          assert_equal 'workflow_name', ChiliVideoPlugin::Config.workflow
          ChiliVideoPlugin::Config.update(@new_values)
          assert_equal @new_values[:workflow], ChiliVideoPlugin::Config.workflow
        end
      end

      context 'when a required parameter is missing' do
        should "an ArgumentError is raised" do
          assert_raise(ArgumentError) {
            ChiliVideoPlugin::Config.update(:api_key => 'api_key')
          }
        end
      end
    end
end
