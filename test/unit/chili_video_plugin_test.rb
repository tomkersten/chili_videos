require File.dirname(__FILE__) + '/../test_helper'

class ChiliVideosTest < ActiveSupport::TestCase
  setup do
    Setting["plugin_chili_videos"] = HashWithIndifferentAccess.new({:transloadit_api_key => 'api_key', :transloadit_workflow => 'workflow'})
  end

  context '.configured?' do
    context "when all required settings are stored" do
      should "return true" do
        assert ChiliVideos.configured?
      end
    end

    context "when 'transloadit_api_key' is not set" do
      should 'returns false' do
        Setting["plugin_chili_videos"]['transloadit_api_key'] = ''
        assert !ChiliVideos.configured?
      end
    end

    context "when 'transloadit_workflow' is not set" do
      should 'returns false' do
        Setting["plugin_chili_videos"]['transloadit_workflow'] = ''
        assert !ChiliVideos.configured?
      end
    end
  end
end

