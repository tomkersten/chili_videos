class VideosController < ApplicationController
  unloadable

  before_filter :verify_plugin_configured, :find_project_by_project_id, :authorize

  def index
    @videos = @project.videos

    unless @project.assemblies.unprocessed.empty?
      flash[:notice] = "There are #{Assembly.unprocessed.count} videos being processed right now. Hang tight..."
    end
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
    if video.blank?
      flash[:error] = "The requested video does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_videos_path(@project))
    end
  end

  def destroy
    video && video.destroy
    flash[:notice] = l(:video_deleted_message)
    redirect_to project_videos_path(@project)
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

    def video
      @video = @project.videos.find_by_cached_slug(params[:id])
    end
end
