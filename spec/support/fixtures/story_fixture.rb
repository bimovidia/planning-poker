module Support
  module Fixtures
    module StoryFixture

      def story_params
        {
          id:             stub_id,
          name:           stub_text,
          current_state:  stub_state,
          description:    stub_words,
          story_type:     stub_text,
          requested_by:   stub_name,
          owned_by:       stub_name
        }
      end

      def stub_stories(project, n = 10)
        project.stubs(:stories).returns((1..n).map { |i| init_object(story_params) })
      end

      def stub_state
        ['accepted', 'delivered' , 'started', 'rejected'].sample
      end

    end
  end
end