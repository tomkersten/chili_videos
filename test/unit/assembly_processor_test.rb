require 'test/test_helper'

class AssemblyProcessorTest < ActiveSupport::TestCase
  context '.process' do
    setup do
      @project = Project.generate!
      @assembly_url = 'http://fake.transload.it/assembly_url'
      @assembly = Assembly.generate!(:project_id => @project.id, :assembly_url => @assembly_url)

      exp_response = 'test/fixtures/single_video_processed_assembly.json'
      FakeWeb.register_uri(:get, @assembly_url, :response => exp_response)
    end

    should 'creates a new Video' do
      Video.destroy_all
      AssemblyProcessor.process(@assembly)
      assert_equal 1, Video.count
    end

    should 'associates the video with the same project as the assembly' do
      AssemblyProcessor.process(@assembly)
      assert_equal @project.id, Video.last.project_id
    end

    context 'when a single video was uploaded' do
      should "the S3 URL of the video associated with the assembly is stored in the 'video_url'" do
        expected_url = 'http://fakebucket.s3.amazonaws.com/f1/192f2b2cb1755ad4494707d82dc7a5/tester.flv'
        AssemblyProcessor.process(@assembly)
        assert_equal expected_url, Video.last.url
      end
    end
  end
end
