# frozen_string_literal: true

require 'dry/struct'
require 'sample_data_dump/types'

module SampleDataDump
  module Entities
    class TableConfiguration < Dry::Struct
      attribute :schema_name, Types::Strict::String
      attribute :table_name, Types::Strict::String
      attribute :dump_where, Types::Strict::String.default('')
      attribute :obfuscate_columns, Types::Strict::Array.of(Types::Strict::String).default([])

      def qualified_table_name
        "#{schema_name}.#{table_name}"
      end
    end
  end
end
