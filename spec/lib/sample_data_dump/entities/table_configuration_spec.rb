# frozen_string_literal: true

require 'spec_helper'

module SampleDataDump
  module Entities
    describe TableConfiguration do
      let(:table_configuration) do
        described_class.new(schema_name: 'my_schema', table_name: 'my_table')
      end

      describe '#qualified_table_name' do
        subject(:qualified_table_name) { table_configuration.qualified_table_name }

        it { is_expected.to eq 'my_schema.my_table' }
      end
    end
  end
end
