# frozen_string_literal: true

module SampleDataDump
  module Commands
    class DownloadCompressedSampleDataDumps
      def initialize(local_file_system_gateway, compressed_dump_storage_gateway)
        @local_file_system_gateway = local_file_system_gateway
        @compressed_dump_storage_gateway = compressed_dump_storage_gateway
      end

      def result
        @local_file_system_gateway.clean_dump_directory.bind do
          @local_file_system_gateway.load_table_configurations.fmap do |table_configs|
            result = process_table_configs_list(table_configs)
            return result if result.failure?
          end
        end
      end

      private

      def process_table_configs_list(table_configs)
        results = table_configs.map do |table_config|
          result = @compressed_dump_storage_gateway.retrieve_compressed_dump_file(table_config)
          return result if result.failure?
        end
        results.last || Dry::Monads::Success(true)
      end
    end
  end
end
