require 'redmine'
require 'httparty'
require 'hashie'

# Patches to the Redmine core.
require 'dispatcher'

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
    video_id = ars[0]
    video = Video.find(args[0])
    if video
      file_url = video.url
    else
      file_url = "im_not_a_video"
    end

<<END
<p id='video_#{@num}'>PLAYER</p>
<script type='text/javascript' src='#{Setting.protocol}://#{Setting.host_name}/plugin_assets/redmine_embedded_video/swfobject.js'></script>
<script type='text/javascript'>
var s1 = new SWFObject('#{Setting.protocol}://#{Setting.host_name}/plugin_assets/redmine_embedded_video/player.swf','player','400','300','9');
s1.addParam('allowfullscreen','true');
s1.addParam('allowscriptaccess','always');
s1.addParam('flashvars','file=#{file_url}');
s1.write('video_#{@num}');
</script>
END
  end
end
