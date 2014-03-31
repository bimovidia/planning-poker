module Support
  module Helpers
    module DashboardHelper

      def encoded_user
        Base64.strict_encode64(
          Forgery(:internet).email_address
        )
      end

      def decoded_user(user)
        Base64.strict_decode64(user)
      end

    end
  end
end