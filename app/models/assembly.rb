class Encoding < Hashie::Mash
end

class Assembly < ActiveRecord::Base
  unloadable

  attr_accessible :project_id, :ssembly_id, :assembly_url, :user_id

  def encodings
    raw_assembly = Retriever.get(assembly_url)
    raise ChiliVideoPlugin::Error::IncompleteAssembly unless raw_assembly["ok"] == "ASSEMBLY_COMPLETED"

    raw_assembly["results"]["encode"].map do |raw_encoding|
      Encoding.new(raw_encoding)
    end
  end


  class << self
    class ::Retriever
      include HTTParty
      format :json
    end
  end
end
