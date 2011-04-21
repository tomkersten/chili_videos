#!/usr/bin/env ruby
$:.unshift('lib')
require 'redmine_plugin_support'
require 'chili_videos'
require 'tasks/contributor_tasks'
require 'tasks/chili_videos_tasks'

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_chili_videos'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :release, :clean, :test]
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

Dir["/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default => [:test]

ChiliVideosTasks.new

begin
  require 'hoe'
  Hoe.plugin :git

  $hoe = Hoe.spec('chili_videos') do
    self.readme_file      = 'README.md'
    self.version          = ChiliVideos::VERSION
    self.extra_rdoc_files = FileList['README.md', 'LICENSE', 'History.txt']
    self.summary = "ChiliProject (/Redmine) plugin which adds self-hosted videos transcoded using the Transload.it service. The plugin a 'Video' tab to a project site which contains any associated videos."
    self.extra_deps       = [
                              ['httparty', '0.7.4'],
                              ['daemon-spawn', '0.4.2'],
                              ['delayed_job', '2.0.4'],
                              ['friendly_id', '3.2.1.1'],
                              ['hashie', '1.0.0']
                            ]
    self.extra_dev_deps   = [['fakeweb', '1.3.0']]
    developer('Tom Kersten', 'tom@whitespur.com')
  end

  ContributorTasks.new
rescue LoadError
  puts "You are missing the 'hoe' gem, which is used for gem packaging & release management."
  puts "Install using 'gem install hoe' if you need packaging & release rake tasks."
end
