require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path


require "webrat"

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
  def transloadit_payload(identifier = :standard)
    YAML.load(File.open("test/fixtures/#{identifier}_transloadit_response.yml"))
  end
end

class ActionController::IntegrationTest
  include IntegrationTestHelper
end

class ActionController::TestCase
  include TransloaditServiceHelper
end
