module VideosHelper
  extend self

  def video_embed_macro_markup(video)
    "{{video(#{video.permalink})}}"
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
    "  s1.write('video_#{video.permalink}');\n" + \
    "</script>\n"
  end

  private
    def swf_object_file_url
      "/plugin_assets/chili_videos/swfobject.js"
    end

    def swf_player_file_url
      "/plugin_assets/chili_videos/player.swf"
    end
end
