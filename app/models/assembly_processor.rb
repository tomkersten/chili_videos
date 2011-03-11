class AssemblyProcessor
  class << self
    def process(assembly)
      assembly.encodings.each do |encoding|
        Video.create!(:project_id => assembly.project_id, :url => encoding.url)
      end
      true
    end
  end
end
