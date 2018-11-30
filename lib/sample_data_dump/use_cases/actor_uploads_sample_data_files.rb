# frozen_string_literal: true

module SampleDataDump
  module UseCases
    class ActorUploadsSampleDataFiles
      def initialize(persistence)
        @persistence = persistence
      end

      def result
        @persistence.load_table_configurations.fmap do |table_configurations|
          result = process_table_configurations_list(table_configurations)
          return result if result.failure?
        end
      end

      private

      def process_table_configurations_list(table_configurations)
        results = table_configurations.map do |table_configuration|
          result = process_table_configuration(table_configuration)
          return result if result.failure?
        end
        results.last || Dry::Monads::Success(true)
      end

      def process_table_configuration(table_configuration)
        @persistence.valid?(table_configuration).bind do
          @persistence.move_compressed_dump_file_to_central_location(table_configuration)
        end
      end
    end
  end
end
