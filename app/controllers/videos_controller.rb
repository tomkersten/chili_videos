class VideosController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @videos = Video.all
  end

  def new
    @api_key = VideoService.api_key
    @workflow = VideoService.workflow

    if !VideoService.configured?
      render :template => 'videos/plugin_not_configured'
    end
  end

  def upload_complete
    File.open('/Users/tom/Desktop/transloadit_response.yaml', 'w+') {|f| f.write(params.to_yaml)}
  end
end
