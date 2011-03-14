module VideoVersionPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_many :videos, :dependent => :destroy
    end
  end
end

