#!/usr/bin/env ruby
require 'redmine_plugin_support'
require 'chili_videos'
require 'lib/tasks/contributor_tasks'

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_chili_videos'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :release, :clean, :test]
  # TODO: gem not getting this automaticly
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

Dir["/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default => [:test]

begin
  require 'hoe'
  Hoe.plugin :git

  $hoe = Hoe.spec('chili_videos') do
    self.summary = "ChiliProject plugin which adds self-hosted videos transcoded using the Transload.it service."
    self.extra_deps       = [['httparty', '0.7.4'], ['delayed_job', '2.0.4']]
    self.readme_file      = 'README.md'
    self.extra_rdoc_files = FileList['README.md', 'LICENSE']
    self.version          = ChiliVideos::VERSION
    developer('Tom Kersten', 'tom@whitespur.com')
  end

  ContributorTasks.new

rescue LoadError
  puts "You are missing the 'hoe' gem, which is used for gem packaging & release management. Install using 'gem install hoe' if you need development rake tasks."
end
