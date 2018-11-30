# frozen_string_literal: true

module SampleDataDump
  module UseCases
    class ActorLoadsSampleDataFiles
      def initialize(persistence)
        @persistence = persistence
      end

      def execute
        @persistence.load_table_configurations.fmap do |table_configurations|
          result = process_table_configurations_list(table_configurations)
          return result if result.failure?
        end
      end

      private

      def process_table_configurations_list(table_configurations)
        table_configurations.reverse_each do |table_configuration|
          @persistence.wipe_table(table_configuration)
        end

        results = table_configurations.map do |table_configuration|
          result = process_table_configuration(table_configuration)
          return result if result.failure?
        end
        results.last || Dry::Monads::Success(true)
      end

      def process_table_configuration(table_configuration)
        @persistence.valid?(table_configuration).bind do
          @persistence.decompress_compressed_dump_file(table_configuration).bind do
            @persistence.load_dump_file(table_configuration).bind do
              @persistence.reset_sequence(table_configuration)
            end
          end
        end
      end
    end
  end
end
