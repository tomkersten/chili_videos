require File.dirname(__FILE__) + '/../test_helper'

class VideoServiceTest < ActiveSupport::TestCase
  setup do
    Setting["plugin_chili_videos"] = HashWithIndifferentAccess.new({:transloadit_api_key => 'api_key', :transloadit_workflow => 'workflow_name'})
  end

    context '.api_key' do
      should "returns the value of the plugin's 'transloadit_api_key' setting" do
        assert_equal 'api_key', VideoService.api_key
      end
    end

    context '.workflow' do
      should "returns the value of the plugin's 'transloadit_workflow' setting" do
        assert_equal 'workflow_name', VideoService.workflow
      end
    end

  context '.configured?' do
    context "when all required settings are stored" do
      should "return true" do
        assert VideoService.configured?
      end
    end

    context "when 'transloadit_api_key' is not set" do
      should 'returns false' do
        Setting["plugin_chili_videos"]['transloadit_api_key'] = ''
        assert !VideoService.configured?
      end
    end

    context "when 'transloadit_workflow' is not set" do
      should 'returns false' do
        Setting["plugin_chili_videos"]['transloadit_workflow'] = ''
        assert !VideoService.configured?
      end
    end
  end
end
