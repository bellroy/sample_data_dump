# frozen_string_literal: true

require 'duckface'

module SampleDataDump
  module Interfaces
    module CompressedDumpStorageGateway
      extend Duckface::ActsAsInterface

      def retrieve_compressed_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def store_compressed_dump_file(_table_configuration)
        raise NotImplementedError
      end
    end
  end
end
