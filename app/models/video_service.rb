module VideoService
  extend self

  def api_key
    Setting['plugin_chili_videos']['transloadit_api_key']
  end

  def workflow
    Setting['plugin_chili_videos']['transloadit_workflow']
  end

  def configured?
    !api_key.blank? && !workflow.blank?
  end
end
