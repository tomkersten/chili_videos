class Encoding < Hashie::Mash
end

class Assembly < ActiveRecord::Base
  unloadable

  ASSEMBLY_STATUS_KEY     = "ok"
  ASSEMBLY_COMPLETE_VALUE = "ASSEMBLY_COMPLETED"

  attr_accessible :project_id, :ssembly_id, :assembly_url, :user_id

  belongs_to :project
  belongs_to :user

  def completed?
    raw_assembly(:reload)[ASSEMBLY_STATUS_KEY] == ASSEMBLY_COMPLETE_VALUE
  end

  def custom_fields
    HashWithIndifferentAccess.new(raw_assembly["fields"])
  end

  def encodings
    raise ChiliVideoPlugin::Error::IncompleteAssembly unless completed?

    raw_assembly["results"]["encode"].map do |raw_encoding|
      Encoding.new(raw_encoding)
    end
  end

  # Retrieves and caches the content of .assembly_url. If you pass
  # in :reload as an argument, it will visit the URL again and replace
  # the existing values.
  #
  # reload_or_not - determines whether the method call should use a cached
  #                 version of the content or not. :reload is the only value
  #                 which will have an impact on the method call.
  #
  # Returns the HTTP response as a Hash
  def raw_assembly(symbol = nil)
    return @raw_assembly if @raw_assembly && symbol != :reload
    @raw_assembly = Retriever.get(assembly_url)
  end

  class << self
    class ::Retriever
      include HTTParty
      format :json
    end
  end
end
