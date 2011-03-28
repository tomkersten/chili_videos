module VideosHelper
  extend self

  def video_embed_macro_markup(video)
    "{{video #{video.to_param}}}"
  end

  def gravatar_enabled?
    Setting['gravatar_enabled'] == '1'
  end

  def video_embed_code(video, size = :standard)
    width = size == :large ? 640 : 560
    height = size == :large ? 390 : 349

    "<script type='text/javascript' src='#{swf_object_file_url}'></script>\n" + \
    "<script type='text/javascript'>\n" + \
    "  var s1 = new SWFObject('#{swf_player_file_url}', 'player', '#{width}','#{height}','9');\n" + \
    "  s1.addParam('allowfullscreen','true');\n" + \
    "  s1.addParam('allowscriptaccess','always');\n" + \
    "  s1.addParam('flashvars','file=#{video.url}');\n" + \
    "  s1.write('video_#{video.to_param}');\n" + \
    "</script>\n"
  end

  private
    def swf_object_file_url
      "#{Setting.protocol}://#{Setting.host_name}/plugin_assets/redmine_chili_videos/swfobject.js"
    end

    def swf_player_file_url
      "#{Setting.protocol}://#{Setting.host_name}/plugin_assets/redmine_chili_videos/player.swf"
    end
end
