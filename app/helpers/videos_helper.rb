module VideosHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
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

  def link_to_video_macro_markup(video)
    "{{video_link(#{video.permalink})}}"
  end

  def link_to_video(video)
    return "[Video not provided]" unless video.instance_of?(Video)
    "<a href='#{prjct_video_path(video.project, video)}' class='video-link'>#{video.title}</a>"
  end

  def video_thumbnail_list(videos)
    "<ul class='videos' style='list-style-type: none; float: left; margin-right: 25px; width: 95%;'>\n" + \
      videos.map do |video|
        "<li class='video' id='#{video.to_param}' style='padding-bottom: 30px; display: inline-block;'>\n" + \
        "  <a href='#{prjct_video_path(video.project, video)}' class='video-cell small' style='float: left; margin-right: 20px; background-color:#000; text-align: right; display: block; width:128px; height:96px;'>\n" + \
        "    <span style='position:relative; top: 81px; padding-right: 3px; color: #CCC; display: block;'>#{video.length}</span>\n" + \
        "  </a>\n" + \
        "<h3 style='border-bottom: none; font-size: 12px; width: 128px; padding: 5px 0 0 0; margin: 0;'>#{link_to(truncate(video.title, :length => 21), prjct_video_path(video.project, video), :title => video.title)}</h3>\n" + \
        "<dl style='margin-top: 0;'>\n" + \
        "  <dt style='float: left; padding-right: 3px;'>by:</dt>\n" \
        "  <dd style='margin: 3px; clear: after; display: block;'>#{link_to(truncate(video.user.name, :length => 17), usr_path(video.user))}</dd>\n" + \
        "</dl>\n" + \
        "</li>\n"
      end.join("\n") + \
    "</ul><div style='clear:both;'></div>"
  end

  private
    def swf_object_file_url
      "/plugin_assets/chili_videos/swfobject.js"
    end

    def swf_player_file_url
      "/plugin_assets/chili_videos/player.swf"
    end

    def prjct_video_path(project, video)
      "/projects/#{project.to_param}/videos/#{video.to_param}"
    end

    def usr_path(user)
      "/users/#{user.to_param}"
    end
end
