require File.dirname(__FILE__) + '/../test_helper'

class AssemblyTest < ActiveSupport::TestCase
  context ".encodings" do
    setup do
      @project = Project.generate!
      @assembly_url = 'http://fake.transload.it/assembly_url/jdskdjfnotreal'
      @assembly = Assembly.generate!(:project_id => @project.id, :assembly_url => @assembly_url)

      exp_response = 'test/fixtures/single_video_processed_assembly.json'
      FakeWeb.register_uri(:get, @assembly_url, :response => exp_response)
    end

    context "when one video was uploaded" do
      should "returns an enumerable with one item" do
        assert 1, @assembly.encodings.count
      end

      should "include the URL of the transcoded file" do
        expected_url = 'http://fakebucket.s3.amazonaws.com/f1/192f2b2cb1755ad4494707d82dc7a5/tester.flv'
        encoding = @assembly.encodings.first
        assert expected_url, encoding.url
      end
    end
  end
end
