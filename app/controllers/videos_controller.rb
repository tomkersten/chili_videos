class VideosController < ApplicationController
  unloadable

  #TODO: wrap configuration check in filter

  before_filter :find_project_by_project_id, :authorize

  def index
    if ChiliVideoPlugin.configured?
      @videos = Video.all
    else
      render :template => 'videos/plugin_not_configured'
    end
  end

  def new
    if ChiliVideoPlugin.configured?
      @api_key = ChiliVideoPlugin::Config.api_key
      @workflow = ChiliVideoPlugin::Config.workflow
    else
      render :template => 'videos/plugin_not_configured'
    end
  end

  def upload_complete
    #TODO: migrate to project.assemblies association
    @assembly = Assembly.create(assembly_params)
  end

  private
    def assembly_params
      { :assembly_id => params[:assembly_id],
        :assembly_url => params[:assembly_url],
        :project_id => @project.id,
        :user_id => User.current.id,
        :processed => false
      }
    end
end
