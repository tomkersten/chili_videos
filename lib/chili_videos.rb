require 'httparty'
require 'hashie'
require 'friendly_id'

require 'delayed_job'
Delayed::Worker.backend = :active_record

require 'chili_videos/config'

module ChiliVideos
  extend self

  VERSION = '0.1.0' unless defined?(ChiliVideos::VERSION)

  def configured?
    !Config.api_key.blank? && !Config.workflow.blank?
  end
end
