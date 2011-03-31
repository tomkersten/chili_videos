class VideosController < ApplicationController
  unloadable

  before_filter :verify_plugin_configured, :find_project_by_project_id, :authorize

  def index
    @videos = @project.videos
  end

  def new
    @api_key = ChiliVideos::Config.api_key
    @workflow = ChiliVideos::Config.workflow
    @versions = @project.versions.open
  end

  def upload_complete
    @project.assemblies.create!(assembly_params)
  end

  def show
    @video = @project.videos.find_by_id(params[:id])

    if @video.blank?
      flash[:error] = "The requested video does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_videos_path(@project))
    end
  end

  private
    def assembly_params
      { :assembly_id => params[:assembly_id],
        :assembly_url => params[:assembly_url],
        :user_id => User.current.id,
        :processed => false
      }
    end

    def verify_plugin_configured
      render(:template => 'videos/plugin_not_configured') unless ChiliVideos.configured?
    end
end
