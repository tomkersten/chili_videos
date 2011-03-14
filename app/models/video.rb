class Video < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :project
  belongs_to :version
end
