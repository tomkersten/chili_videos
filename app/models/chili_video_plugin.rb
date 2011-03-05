require 'chili_video_plugin/config'

module ChiliVideoPlugin
  extend self

  def configured?
    !Config.api_key.blank? && !Config.workflow.blank?
  end
end
