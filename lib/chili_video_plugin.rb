require 'chili_video_plugin/config'

module ChiliVideoPlugin
  extend self

  VERSION = '0.1.0' unless defined?(ChiliVideoPlugin::VERSION)

  def configured?
    !Config.api_key.blank? && !Config.workflow.blank?
  end
end
