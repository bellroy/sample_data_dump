# frozen_string_literal: true

require 'dry/monads/all'
require 'sample_data_dump/entities/table_configuration'
require 'sample_data_dump/interfaces/persistence'
require 'sample_data_dump/use_cases/actor_downloads_sample_data_files'

module SampleDataDump
  module UseCases
    describe ActorDownloadsSampleDataFiles do
      let(:use_case) { described_class.new(persistence) }

      let(:persistence) { instance_double(Interfaces::Persistence) }

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

      describe '#execute' do
        subject(:execute) { use_case.execute }

        before do
          expect(persistence)
            .to receive(:load_table_configurations)
            .and_return(Dry::Monads::Success([table_configuration_one, table_configuration_two]))

          expect(persistence)
            .to receive(:valid?)
            .with(table_configuration_one)
            .and_return(Dry::Monads::Success(true))
          expect(persistence)
            .to receive(:valid?)
            .with(table_configuration_two)
            .and_return(Dry::Monads::Success(true))

          expect(persistence)
            .to receive(:retrieve_compressed_dump_file_from_central_location)
            .with(table_configuration_one)
            .and_return(Dry::Monads::Success(true))

          expect(persistence)
            .to receive(:retrieve_compressed_dump_file_from_central_location)
            .with(table_configuration_two)
            .and_return(Dry::Monads::Success(true))
        end

        it { is_expected.to be_success }
      end
    end
  end
end
