require 'rake'
require 'rake/tasklib'

class ChiliVideosTasks < Rake::TaskLib
  VALID_DJ_ACTIONS = %w(start restart stop status)

  def initialize
    define
  end

  def define
    namespace :chili_videos do
      desc "Install ChiliVideos plugin (migrate database, include assets, etc)"
      task :install => [:migrate_db, :symlink_assets]

      desc "Uninstalls ChiliVideos plugin (removes database modifications, removes assets, etc)"
      task :uninstall => [:environment] do
        puts "Removing ChiliVideos database modifications..."
        migrate_db(:to_version => 0)

        puts "Removing link to ChiliVideo assets (stylesheets, js, etc)..."
        remove_symlink asset_destination_dir

        puts post_uninstall_steps
      end

      desc "Manage delayed_job...requires argument [ACTION=(#{VALID_DJ_ACTIONS.join('|')})]"
      task :delayed_job, 'action' => [:environment] do |task, args|
        unless(args[:action] && VALID_DJ_ACTIONS.include?(args[:action]))
          puts "'ACTION' is a required parameter. Valid values are: #{VALID_DJ_ACTIONS.join(', ')}"
          exit(1)
        end

        shell_command = "RAILS_ROOT='#{application_root}' RAILS_ENV=#{RAILS_ENV} #{File.expand_path(delayed_job_path)} #{args[:action]}"
        puts "Issuing '#{args[:action]}' command to delayed_job executable (bundled with ChiliVideos)"
        sh shell_command do |ok, status|
          ok || fail("Command failed (status: #{status}) (command: '#{shell_command}')")
        end
      end

      task :migrate_db => [:environment] do
        puts "Migrating chili_videos-#{ChiliVideos::VERSION}..."
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(gem_db_migrate_dir, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end

      task :symlink_assets => [:environment] do
        # HACK: Symlinks the files from plugindir/assets to the appropriate place in
        # the rails application
        puts "Symlinking assets (stylesheets, etc)..."
        add_symlink asset_source_dir, asset_destination_dir
      end
    end
  end

  private
    def application_root
      File.expand_path(RAILS_ROOT)
    end

    def gem_root
      @gem_root ||= File.expand_path(File.dirname(__FILE__) + "/../..")
    end

    def asset_destination_dir
      @destination_dir ||= File.expand_path("#{application_root}/public/plugin_assets/chili_videos")
    end

    def asset_source_dir
      @source_dir ||= File.expand_path(gem_root + "/assets")
    end

    def gem_db_migrate_dir
      @gem_db_migrate_dir ||= File.expand_path(gem_root + "/db/migrate")
    end

    def delayed_job_path
      @delayed_job_path ||= File.expand_path(gem_root + "/bin/delayed_job")
    end

    def remove_symlink(symlink_file)
      system("unlink #{symlink_file}") if File.exists?(symlink_file)
    end

    def add_symlink(source, destination)
      remove_symlink destination
      system("ln -s #{source} #{destination}")
    end

    def migrate_db(options = {})
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(gem_db_migrate_dir, options[:to_version])
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    def post_uninstall_steps
      [
        "!!!!! MANUAL STEPS !!!!!",
        "\t1. In your 'config/environment.rb', remove:",
        "\t\tconfig.gem 'chili_videos'",
        "",
        "\t2. In your 'Rakefile', remove:",
        "\t\trequire 'chili_videos'",
        "\t\trequire 'tasks/chili_videos_tasks'",
        "\t\tChiliVideosTasks.new",
        "",
        "\t3. Cycle your application server (mongrel, unicorn, etc)",
        "\n",
      ].join("\n")
    end
end
