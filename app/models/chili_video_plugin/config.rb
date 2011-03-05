module ChiliVideoPlugin
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

    private
      def plugin_settings
        Setting[PLUGIN_KEYNAME]
      end
  end
end
