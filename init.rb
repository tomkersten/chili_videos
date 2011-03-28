require 'redmine'
require 'httparty'
require 'hashie'

# Patches to the Redmine core.
require 'dispatcher'
require 'videos_helper'

Dispatcher.to_prepare :question_plugin do
  require_dependency 'project'
  Project.send(:include, VideoProjectPatch) unless Project.included_modules.include? VideoProjectPatch

  require_dependency 'user'
  User.send(:include, VideoUserPatch) unless User.included_modules.include? VideoUserPatch

  require_dependency 'version'
  Version.send(:include, VideoVersionPatch) unless Version.included_modules.include? VideoVersionPatch
end


Redmine::Plugin.register :chili_videos do
  name 'Chili Videos plugin'
  author 'Tom Kersten'
  description 'Adds support for using the Transload.it service to transcode videos and associate them with projects.'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://tomkersten.com/'

  project_module :videos do
    permission :view_video_list, :videos => :index
    permission :view_specific_video, :videos => :show
    permission :modify_videos, :videos => [:edit,:update]
    permission :delete_video, :videos => :destroy
    permission :add_video, :videos => [:new, :create, :upload_complete]
  end

  settings :default => {:transloadit_api_key => '', :transloadit_workflow => ''}, :partial => 'settings/settings'

  menu :project_menu, :videos, { :controller => 'videos', :action => 'index' }, :caption => 'Videos', :param => :project_id

  ActiveRecord::Base.observers << :assembly_observer
end

Redmine::WikiFormatting::Macros.register do
  desc "Embeds a flv file into flash video player.\n" +
       "Usage examples:\n\n" +
       "  !{{video(id)}}\n"
  macro :video do |o, args|
    video_id = args[0]
    size = args[1] || :standard

    video = Video.find(video_id)
    if video
      file_url = video.url
    else
      file_url = "im_not_a_video"
    end

<<END
<div class="video-cell large" id="video_#{video.to_param}"></div>
#{VideosHelper.video_embed_code(video, size)}
END
  end
end
