require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path


require 'webrat'
require 'fakeweb'
require 'chili_videos'

FakeWeb.allow_net_connect = false

Webrat.configure do |config|
  config.mode = :rails
end

module IntegrationTestHelper
  def login_as(user="existing", password="existing")
    visit "/login"
    fill_in 'Login', :with => user
    fill_in 'Password', :with => password
    click_button 'login'
    assert_response :success
    assert User.current.logged?
  end

  def visit_project(project)
    visit '/'
    assert_response :success

    click_link 'Projects'
    assert_response :success

    click_link project.name
    assert_response :success
  end

  def assert_forbidden
    assert_response :forbidden
    assert_template 'common/403'
  end

  # Cleanup current_url to remove the host; sometimes it's present, sometimes it's not
  def current_path
    return nil if current_url.nil?
    return current_url.gsub("http://www.example.com","")
  end

end

module TransloaditServiceHelper
  def workflow_results(identifier = :standard)
    YAML.load(File.open("test/fixtures/#{identifier}_transloadit_response.json"))
  end

  def stub_assembly_url(assembly = nil, fixture_base_name = :single_video_processed)
    response = "test/fixtures/#{fixture_base_name.to_s}_assembly.json"
    url = assembly.blank? ? assembly_url : assembly.assembly_url
    FakeWeb.register_uri(:get, url, :response => response)
  end

  def assembly_url
    'http://fake.transload.it/assembly_url'
  end
end

class ActionController::IntegrationTest
  include IntegrationTestHelper
end

class ActiveSupport::TestCase
  include TransloaditServiceHelper
end

class ActionController::TestCase
  include TransloaditServiceHelper
end
