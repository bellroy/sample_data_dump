# frozen_string_literal: true

require 'duckface'

module SampleDataDump
  module Interfaces
    module LocalFileSystemGateway
      extend Duckface::ActsAsInterface

      def clean_dump_directory
        raise NotImplementedError
      end

      def compress_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def decompress_compressed_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def load_table_configurations
        raise NotImplementedError
      end
    end
  end
end
