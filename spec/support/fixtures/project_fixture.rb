module Support
  module Fixtures
    module ProjectFixture

      def project_params
        {
          id:               stub_id,
          name:             stub_text,
          velocity_averaged_over:  stub_id,
          label_list:           stub_labels,
          point_scale:      stub_point_scale
        }
      end

      def stub_projects(projects = [])
        @client.stubs(:projects).returns(projects)
      end

      def stub_labels(n = 5)
        (1..n).map { |index| "label#{index}" }.join(',')
      end

      def stub_point_scale(n = 5)
        (1..n).to_a.join(',')
      end

    end
  end
end