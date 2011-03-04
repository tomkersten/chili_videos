require 'redmine'

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
end
