class Video < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :project
  belongs_to :version

  def length
    return "0:00" if duration.blank?
    minutes = duration / 60
    seconds = duration % 60
    "#{minutes}:#{seconds.to_s.rjust(2,'0')}"
  end
end
