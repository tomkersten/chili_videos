class VideosController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @videos = Video.all
  end

  def new
    settings = Setting["plugin_chili_videos"]
    @api_key = settings['transloadit_api_key']
    @workflow = settings['transloadit_workflow']
    if @api_key.blank? || @workflow.blank?
      render :template => 'videos/plugin_not_configured'
    end
  end

  def upload_complete
    File.open('/Users/tom/Desktop/transloadit_response.yaml', 'w+') {|f| f.write(params.to_yaml)}
  end
end
