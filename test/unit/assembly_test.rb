require File.dirname(__FILE__) + '/../test_helper'

class AssemblyTest < ActiveSupport::TestCase
  def setup
    @project = Project.generate!
    stub_assembly_url
  end

  context ".encodings" do
    setup do
      @assembly = Assembly.generate!(:project_id => @project.id, :assembly_url => assembly_url)
    end

    context "when one video was uploaded it should" do
      setup do
        service_response = 'test/fixtures/single_video_processed_assembly.json'
        FakeWeb.register_uri(:get, assembly_url, :response => service_response)
      end

      should "return an enumerable with one item" do
        assert 1, @assembly.encodings.count
      end

      should "include the URL of the transcoded file" do
        expected_url = 'http://fakebucket.s3.amazonaws.com/f1/192f2b2cb1755ad4494707d82dc7a5/tester.flv'
        encoding = @assembly.encodings.first
        assert expected_url, encoding.url
      end
    end

    context "when the workflow has not completed yet" do
      setup do
        service_response = 'test/fixtures/incomplete_assembly.json'
        FakeWeb.register_uri(:get, assembly_url, :response => service_response)
      end

      should "raises an IncompleteAssembly exception" do
        assert_raise(ChiliVideoPlugin::Error::IncompleteAssembly) {@assembly.encodings}
      end
    end
  end

  context "processing" do
    context "after an assembly is successfully created it" do
      setup do
        Video.destroy_all
      end

      should "process the assembly and create a new video" do
        @assembly = Assembly.generate!(:project_id => @project.id, :assembly_url => assembly_url)
        assert_equal 1, Video.count
      end
    end
  end
end
