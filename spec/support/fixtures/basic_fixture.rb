module Support
  module Fixtures
    module BasicFixture

      def stub_id
        rand(1000000)
      end

      def stub_text
        Forgery::Basic.text
      end

      def stub_words(n = 5)
        Forgery::LoremIpsum.words(n)
      end

      def stub_name
        Forgery::Name.full_name
      end

      def init_object(attrs = {})
        OpenStruct.new(attrs)
      end

      def stub_user(user = nil)
        User.stubs(:authenticate).returns(user)
      end

    end
  end
end