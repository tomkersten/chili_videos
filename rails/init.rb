require File.dirname(__FILE__) + "/../init"

source_dir = "#{File.dirname(__FILE__)}/../assets"
destination_dir = "#{RAILS_ROOT}/public/plugin_assets/chili_videos"

# HACK: Symlinks the files from plugindir/assets to the appropriate place in
# the rails application
system("unlink #{destination_dir}") if File.exists?(destination_dir)

puts "Symlinking ChiliVideo asset files to #{destination_dir}"
system("ln -s #{source_dir} #{destination_dir}")
