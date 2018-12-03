# frozen_string_literal: true

require 'duckface'

module SampleDataDump
  module Interfaces
    module DataStoreGateway
      extend Duckface::ActsAsInterface

      def dump_to_local_file(_table_configuration)
        raise NotImplementedError
      end

      def load_dump_file(_table_configuration)
        raise NotImplementedError
      end

      def reset_sequence(_table_configuration)
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
