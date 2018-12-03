# frozen_string_literal: true

require 'dry/monads/all'
require 'sample_data_dump/entities/table_configuration'
require 'sample_data_dump/interfaces/compressed_dump_storage_gateway'
require 'sample_data_dump/interfaces/local_file_system_gateway'
require 'sample_data_dump/commands/upload_compressed_sample_data_dumps'

module SampleDataDump
  module Commands
    describe UploadCompressedSampleDataDumps do
      let(:command) do
        described_class.new(local_file_system_gateway, compressed_dump_storage_gateway)
      end

      let(:local_file_system_gateway) { instance_double(Interfaces::LocalFileSystemGateway) }
      let(:compressed_dump_storage_gateway) do
        instance_double(Interfaces::CompressedDumpStorageGateway)
      end

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

      describe '#result' do
        subject(:result) { command.result }

        before do
          expect(local_file_system_gateway)
            .to receive(:load_table_configurations)
            .and_return(Dry::Monads::Success([table_configuration_one, table_configuration_two]))

          expect(compressed_dump_storage_gateway)
            .to receive(:store_compressed_dump_file)
            .with(table_configuration_one)
            .and_return(Dry::Monads::Success(true))

          expect(compressed_dump_storage_gateway)
            .to receive(:store_compressed_dump_file)
            .with(table_configuration_two)
            .and_return(Dry::Monads::Success(true))
        end

        it { is_expected.to be_success }
      end
    end
  end
end
