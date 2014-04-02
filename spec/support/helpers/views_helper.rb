module Support
  module Helpers
    module ViewsHelper

      def project_nodes
        page.all('#menu li')
      end

      def story_nodes
        page.all('#stories .story')
      end

      def story_node(id)
        find("#story-#{id}")
      end

    end
  end
end