# frozen_string_literal: true

require 'dry/monads/all'
require 'sample_data_dump/entities/table_configuration'
require 'sample_data_dump/helpers/dump_file'
require 'sample_data_dump/interfaces/local_file_system_gateway'
require 'yaml'

module SampleDataDump
  module Gateways
    class LocalFileSystem
      extend Forwardable
      implements_interface Interfaces::LocalFileSystemGateway

      def initialize(settings)
        @settings = settings
        @sample_data_dump_config = YAML.load_file(config_file_path)

        `mkdir -p #{compacted_dump_directory}`
      end

      def clean_dump_directory
        `rm -rf #{compacted_dump_directory}/*.sql`
        `rm -rf #{compacted_dump_directory}/*.sql.tar.gz`
        Dry::Monads::Success(true)
      end

      def compress_dump_file(table_configuration)
        dump_file_helper = Helpers::DumpFile.new(table_configuration, @settings)
        uncompressed_file_path = dump_file_helper.local_dump_file_path
        uncompressed_file_name = dump_file_helper.local_dump_file_name
        compressed_file_name = dump_file_helper.local_compressed_dump_file_name
        compressed_file_path = dump_file_helper.local_compressed_dump_file_path

        unless File.exists?(uncompressed_file_path)
          return Dry::Monads::Failure("No file found at #{uncompressed_file_path}")
        end

        `cd #{compacted_dump_directory}; tar -zcf #{compressed_file_name} #{uncompressed_file_name}`

        if File.exist?(compressed_file_path)
          Dry::Monads::Success(compressed_file_path)
        else
          Dry::Monads::Failure("No file found at #{compressed_file_path} after compressing")
        end
      end

      def decompress_compressed_dump_file(table_configuration)
        dump_file_helper = Helpers::DumpFile.new(table_configuration, @settings)
        compressed_file_name = dump_file_helper.local_compressed_dump_file_name
        compressed_file_path = dump_file_helper.local_compressed_dump_file_path
        unless File.exist?(compressed_file_path)
          return Dry::Monads::Failure("#{compressed_file_path} does not exist for decompressing!")
        end

        `cd #{compacted_dump_directory}; tar -zxf #{compressed_file_name}`
        Dry::Monads::Success(true)
      end

      def load_table_configurations
        result = []
        @sample_data_dump_config.each_pair do |schema_name, schema_config_hash|
          schema_config_hash.each_pair do |table_name, table_config_hash|
            dump_where = table_config_hash&.[]('dump_where') || '1 = 1'
            obfuscate_columns = table_config_hash&.[]('obfuscate_columns') || []
            result << Entities::TableConfiguration.new(
              schema_name: schema_name,
              table_name: table_name,
              dump_where: dump_where,
              obfuscate_columns: obfuscate_columns
            )
          end
        end
        Dry::Monads::Success(result)
      end

      private

      attr_reader :settings
      def_delegators :settings, :compacted_dump_directory, :config_file_path
    end
  end
end
