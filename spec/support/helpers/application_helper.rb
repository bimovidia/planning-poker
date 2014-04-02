module Support
  module Helpers
    module ApplicationHelper

      def t(locale)
        I18n.translate(locale)
      end

    end
  end
end