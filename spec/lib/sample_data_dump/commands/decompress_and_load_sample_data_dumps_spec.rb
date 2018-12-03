# frozen_string_literal: true

require 'dry/monads/all'
require 'sample_data_dump/entities/table_configuration'
require 'sample_data_dump/interfaces/data_store_gateway'
require 'sample_data_dump/interfaces/local_file_system_gateway'

require 'sample_data_dump/commands/decompress_and_load_sample_data_dumps'

module SampleDataDump
  module Commands
    describe DecompressAndLoadSampleDataDumps do
      let(:command) do
        described_class.new(local_file_system_gateway, data_store_gateway)
      end

      let(:local_file_system_gateway) { instance_double(Interfaces::LocalFileSystemGateway) }
      let(:data_store_gateway) { instance_double(Interfaces::DataStoreGateway) }

      let(:table_configuration_one) do
        instance_double(
          Entities::TableConfiguration,
          schema_name: 'schema_name',
          table_name: 'first_table_name'
        )
      end
      let(:table_configuration_two) do
        instance_double(
          Entities::TableConfiguration,
          schema_name: 'schema_name',
          table_name: 'second_table_name'
        )
      end
      let(:table_configurations) { [table_configuration_one, table_configuration_two] }

      describe '#result' do
        subject(:result) { command.result }

        before do
          expect(local_file_system_gateway)
            .to receive(:load_table_configurations)
            .and_return(Dry::Monads::Success(table_configurations))

          table_configurations.each do |table_configuration|
            expect(data_store_gateway)
              .to receive(:wipe_table)
              .with(table_configuration)

            expect(data_store_gateway)
              .to receive(:valid?)
              .with(table_configuration)
              .and_return(Dry::Monads::Success(true))
            expect(local_file_system_gateway)
              .to receive(:decompress_compressed_dump_file)
              .with(table_configuration)
              .and_return(Dry::Monads::Success(true))
            expect(data_store_gateway)
              .to receive(:load_dump_file)
              .with(table_configuration)
              .and_return(Dry::Monads::Success(true))
            expect(data_store_gateway)
              .to receive(:reset_sequence)
              .with(table_configuration)
              .and_return(Dry::Monads::Success(true))
          end
        end

        it { is_expected.to be_success }
      end
    end
  end
end
