class VideosController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @videos = Video.all
  end

  def new
    @api_key = ChiliVideoPlugin::Config.api_key
    @workflow = ChiliVideoPlugin::Config.workflow

    if !ChiliVideoPlugin.configured?
      render :template => 'videos/plugin_not_configured'
    end
  end

  def upload_complete
    File.open('/Users/tom/Desktop/transloadit_response.yaml', 'w+') {|f| f.write(params.to_yaml)}
  end
end
