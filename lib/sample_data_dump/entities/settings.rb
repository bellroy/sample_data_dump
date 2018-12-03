# frozen_string_literal: true

require 'dry/struct'
require 'sample_data_dump/types'

module SampleDataDump
  module Entities
    class Settings < Dry::Struct
      attribute :compacted_dump_directory, Types::Strict::String.default('compacted_dump')
      attribute :config_file_path, Types::Strict::String.default('config/sample_data_dump.yml')
    end
  end
end
