module Support
  module Helpers
    module SessionsHelper

      # Allows to get authenticated user without going through full authentication process.
      # To use this method you need to pass a class of the controller, example:
      #
      #   skip_authentication(DashboardController)
      #
      def skip_authentication(controller)
        controller.any_instance.stubs(:require_authentication).returns(false)
        controller.any_instance.stubs(:current_user).returns(user)

        page.set_rack_session(
          user: {
            username: user.username,
            token:    user.token
          }
        )
      end

      # Login steps to authenticate user.
      # This method will stub a user and logs the user in to the system
      #
      def login
        visit login_path

        fill_in 'username', with: Forgery(:internet).email_address
        fill_in 'password', with: Forgery(:basic).password

        click_button t('signin').upcase
      end

      def logout
        click_link t('signout')
      end

      private

      def user
        @user ||= FactoryBot.create(:user)
      end
    end
  end
end