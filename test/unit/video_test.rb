require File.dirname(__FILE__) + '/../test_helper'

class VideoTest < ActiveSupport::TestCase
  context "#length" do
    context "when video is less than 1-minute" do
      should "convert it to 0:XX format" do
        video = Video.create!(:title => "Video 1", :duration => 32, :project_id => 1, :user_id => 1)
        assert_equal "0:32", video.length
      end
    end

    context "when video is longer than 1-minute" do
      should "convert it to X:XX format" do
        video = Video.create!(:title => "Video 1", :duration => 202, :project_id => 1, :user_id => 1)
        assert_equal "3:22", video.length
      end
    end

    context "when video duration is nil" do
      should "return '0:00'" do
        video = Video.create!(:title => "Video 1", :duration => nil, :project_id => 1, :user_id => 1)
        assert_equal "0:00", video.length
      end
    end
  end
end
