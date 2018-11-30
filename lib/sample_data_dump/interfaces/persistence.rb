# frozen_string_literal: true

require 'duckface'

module SampleDataDump
  module Interfaces
    module Persistence
      extend Duckface::ActsAsInterface

      def decompress_compressed_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def dump_and_compress_data_to_local_file(_table_configuration)
        raise NotImplementedError
      end

      def load_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def load_table_configurations
        raise NotImplementedError
      end

      def move_compressed_dump_file_to_central_location(_table_configuration)
        raise NotImplementedError
      end

      def reset_sequence(_table_configuration)
        raise NotImplementedError
      end

      def retrieve_compressed_dump_file_from_central_location(_table_configuration)
        raise NotImplementedError
      end

      def valid?(_table_configuration)
        raise NotImplementedError
      end

      def wipe_table(_table_configuration)
        raise NotImplementedError
      end
    end
  end
end
