# frozen_string_literal: true

module SampleDataDump
  module Commands
    class DecompressAndLoadSampleDataDumps
      def initialize(local_file_system_gateway, data_store_gateway)
        @local_file_system_gateway = local_file_system_gateway
        @data_store_gateway = data_store_gateway
      end

      def result
        @local_file_system_gateway.load_table_configurations.fmap do |table_configs|
          result = process_table_configs_list(table_configs)
          return result if result.failure?
        end
      end

      private

      def process_table_configs_list(table_configs)
        table_configs.reverse_each do |table_config|
          @data_store_gateway.wipe_table(table_config)
        end

        results = table_configs.map do |table_config|
          result = process_table_config(table_config)
          return result if result.failure?
        end
        results.last || Dry::Monads::Success(true)
      end

      def process_table_config(table_config)
        @data_store_gateway.valid?(table_config).bind do
          @local_file_system_gateway.decompress_compressed_dump_file(table_config).bind do
            @data_store_gateway.load_dump_file(table_config).bind do
              @data_store_gateway.reset_sequence(table_config)
            end
          end
        end
      end
    end
  end
end
