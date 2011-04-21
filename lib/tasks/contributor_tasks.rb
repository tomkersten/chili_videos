require 'rake'
require 'rake/tasklib'

class ContributorTasks < Rake::TaskLib
  def initialize
    define
  end

  def define
    desc "Update contributors list in README"
    task :update_contributors do
      if new_contributors?
        puts "New contributors!"
        new_contributors.each {|name| puts "- #{name}"}
        puts ""

        print "Updating the 'Contributors' section of README..."

        File.open("README.md", "w+") do |file|
          file.puts readme_without_contributors_section
          file.puts "## Contributors (sorted alphabetically)"
          file.puts ""
          committers.each {|name| file.puts "* #{name}"}
        end
        puts "done!"
      else
        puts "No new contributors."
      end
    end
  end

  private
    def all_committers
      all_names = `git shortlog -s |cut -s -f2`
      all_names.gsub!(/\sand\s/, "\n").split("\n").uniq!.sort!
    end

    def committers
      excluded_committers = ["Tom Kersten"]
      @committers ||= all_committers - excluded_committers
    end

    def readme_file_contents
      @readme_contents ||= `cat README.md`
    end

    def existing_contributors
      existing_contributors = readme_file_contents[/## Contributors(.|\n)*/].strip.split("\n* ")
      existing_contributors.shift # remove "Contributors..." line
      existing_contributors
    end

    def new_contributors
      @new_contributors ||= committers - existing_contributors
    end

    def new_contributors?
      !new_contributors.empty?
    end

    def readme_without_contributors_section
      readme_file_contents.sub(/## Contributors(.|\n)*/, '')
    end
end
