require File.dirname(__FILE__) + "/../init"

source_dir = "#{File.dirname(__FILE__)}/../assets"
destination_dir = "#{RAILS_ROOT}/public/plugin_assets/chili_videos"

# HACK: Copies the files from plugindir/assets to the appropriate place in
# the rails application
puts "Copying ChiliVideo asset files to #{destination_dir}"
system("cp -r #{source_dir} #{destination_dir}")
