# frozen_string_literal: true

module SampleDataDump
  module Helpers
    class DumpFile
      extend Forwardable

      def initialize(table_configuration, settings)
        @table_configuration = table_configuration
        @settings = settings
      end

      def local_compressed_dump_file_name
        "#{@table_configuration.schema_name}.#{@table_configuration.table_name}.sql.tar.gz"
      end

      def local_compressed_dump_file_path
        "#{compacted_dump_directory}/#{local_compressed_dump_file_name}"
      end

      def local_dump_file_name
        "#{@table_configuration.schema_name}.#{@table_configuration.table_name}.sql"
      end

      def local_dump_file_path
        "#{compacted_dump_directory}/#{local_dump_file_name}"
      end

      private

      attr_reader :settings
      def_delegators :settings, :compacted_dump_directory
    end
  end
end
