require 'test/test_helper'

class AssemblyProcessorTest < ActiveSupport::TestCase
  context '.process' do
    setup do
      stub_assembly_url

      @project = Project.generate!
      @assembly = Assembly.generate!(:project_id => @project.id, :assembly_url => assembly_url)
    end

    should 'create a new Video' do
      Video.destroy_all
      AssemblyProcessor.process(@assembly)
      assert_equal 1, Video.count
    end

    should 'associate the video with the same project as the assembly' do
      AssemblyProcessor.process(@assembly)
      assert_equal @project.id, Video.last.project_id
    end

    should 'associate the video with the same user as the assembly' do
      AssemblyProcessor.process(@assembly)
      assert_equal @assembly.user_id, Video.last.user_id
    end

    context 'when a single video was uploaded it' do
      should "store the S3 URL of the video associated with the assembly in the 'video_url' attribute" do
        expected_url = 'http://fakebucket.s3.amazonaws.com/f1/192f2b2cb1755ad4494707d82dc7a5/tester.flv'
        AssemblyProcessor.process(@assembly)
        assert_equal expected_url, Video.last.url
      end

      should "store the value of the 'title' custom field on the video" do
        AssemblyProcessor.process(@assembly)
        assert_equal 'Title here', Video.last.title
        #assert_equal 'Description here', Video.last.description
      end

      should "store the value of the 'description' custom field on the video" do
        AssemblyProcessor.process(@assembly)
        assert_equal 'Description here', Video.last.description
      end

      should "store the value of the 'version_id' custom field on the video" do
        AssemblyProcessor.process(@assembly)
        assert_equal 2, Video.last.version_id
      end

      should "store the duration of the video" do
        AssemblyProcessor.process(@assembly)
        assert_equal 10, Video.last.duration
      end
    end
  end
end
