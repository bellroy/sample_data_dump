# frozen_string_literal: true

module SampleDataDump
  module Commands
    class UploadCompressedSampleDataDumps
      def initialize(local_file_system_gateway, compressed_dump_storage_gateway)
        @local_file_system_gateway = local_file_system_gateway
        @compressed_dump_storage_gateway = compressed_dump_storage_gateway
      end

      def result
        @local_file_system_gateway.load_table_configurations.fmap do |table_configs|
          result = process_table_configs_list(table_configs)
          return result if result.failure?
        end
      end

      private

      def process_table_configs_list(table_configs)
        results = table_configs.map do |config|
          result = @compressed_dump_storage_gateway.store_compressed_dump_file(config)
          return result if result.failure?
        end
        results.last || Dry::Monads::Success(true)
      end
    end
  end
end
