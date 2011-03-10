class VideosController < ApplicationController
  unloadable

  #TODO: wrap configuration check in filter

  before_filter :verify_plugin_configured, :find_project_by_project_id, :authorize

  def index
    @videos = Video.all
  end

  def new
    @api_key = ChiliVideoPlugin::Config.api_key
    @workflow = ChiliVideoPlugin::Config.workflow
  end

  def upload_complete
    #TODO: migrate to project.assemblies association
    Assembly.create!(assembly_params)
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

    def verify_plugin_configured
      render(:template => 'videos/plugin_not_configured') unless ChiliVideoPlugin.configured?
    end
end
