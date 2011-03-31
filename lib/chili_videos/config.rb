module ChiliVideos
  module Config
    extend self

    PLUGIN_KEYNAME = 'plugin_chili_videos'
    API_KEY_KEYNAME = 'transloadit_api_key'
    WORKFLOW_KEYNAME = 'transloadit_workflow'

    def api_key
      plugin_settings[API_KEY_KEYNAME]
    end

    def workflow
      plugin_settings[WORKFLOW_KEYNAME]
    end

    # Accepts anything which responds to '[]' and '.has_key?' # (Hash-like objects)
    #
    # Requires & utilizes the following keys
    #   - :api_key
    #   - :workflow
    def update(options)
      unless options.has_key?(:api_key) && options.has_key?(:workflow)
        raise ArgumentError, "Missing key(s) in: #{options.inspect}"
      end
      Setting[PLUGIN_KEYNAME] = formatted_hash(options[:api_key], options[:workflow])
      true
    end

    private
      def plugin_settings
        Setting[PLUGIN_KEYNAME]
      end

      def formatted_hash(api_key, workflow)
        HashWithIndifferentAccess.new({API_KEY_KEYNAME => api_key,
                                      WORKFLOW_KEYNAME => workflow})
      end
  end
end
