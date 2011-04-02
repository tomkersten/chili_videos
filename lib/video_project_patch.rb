module VideoProjectPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_many :videos, :dependent => :destroy, :order => "created_at DESC"
      has_many :assemblies, :dependent => :destroy
    end
  end
end

