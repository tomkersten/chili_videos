module VideosHelper
  def video_embed_macro_markup(video)
    "{{video #{video.to_param}}}"
  end
end
