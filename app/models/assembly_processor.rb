class AssemblyProcessor
  class << self
    def process(assembly)
      assembly.encodings.each do |encoding|
        Video.create!({:title => assembly.custom_fields[:title],
                       :description => assembly.custom_fields[:description],
                       :version_id => assembly.custom_fields[:version_id],
                       :project_id => assembly.project_id,
                       :duration => encoding.meta.duration.to_i,
                       :user_id => assembly.user_id,
                       :url => encoding.url})
      end
      true
    end
  end
end
