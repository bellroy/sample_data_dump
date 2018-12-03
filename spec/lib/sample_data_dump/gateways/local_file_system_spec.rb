# frozen_string_literal: true

require 'sample_data_dump/entities/settings'
require 'sample_data_dump/gateways/local_file_system'

module SampleDataDump
  module Gateways
    describe LocalFileSystem do
      let(:local_file_system) { described_class.new(settings) }

      let(:config_file_path) do
        File.dirname(__FILE__) + '/../../../support/fixtures/sample_data_dump.yml'
      end
      let(:settings) { Entities::Settings.new(config_file_path: config_file_path) }

      describe '#clean_dump_directory' do
        subject(:clean_dump_directory) { local_file_system.clean_dump_directory }

        let(:sql_file_path) { settings.compacted_dump_directory + '/my-file.sql' }
        let(:tar_file_path) { settings.compacted_dump_directory + '/my-file.sql.tar.gz' }

        before do
          `touch #{sql_file_path}`
          `touch #{tar_file_path}`
          expect(File.exist?(sql_file_path)).to be true
          expect(File.exist?(tar_file_path)).to be true
        end

        specify do
          expect(clean_dump_directory).to be_success
          expect(File.exist?(sql_file_path)).to be false
          expect(File.exist?(tar_file_path)).to be false
        end
      end

      describe '#compress_dump_file' do
        subject(:compress_dump_file) { local_file_system.compress_dump_file(table_configuration) }

        let(:table_configuration) { local_file_system.load_table_configurations.value!.first }

        let(:sql_file_path) do
          settings.compacted_dump_directory + '/my_schema_name.my_table_name.sql'
        end
        let(:tar_file_path) do
          settings.compacted_dump_directory + '/my_schema_name.my_table_name.sql.tar.gz'
        end

        context do
          before do
            `touch #{sql_file_path}`
            expect(File.exist?(sql_file_path)).to be true
          end

          specify do
            expect(compress_dump_file).to be_success
            expect(File.exist?(sql_file_path)).to be true
            expect(File.exist?(tar_file_path)).to be true
          end
        end

        context do
          before do
            `rm #{sql_file_path}`
            expect(File.exist?(sql_file_path)).to be false
          end

          specify { expect(compress_dump_file).to be_failure }
        end
      end

      describe '#decompress_compressed_dump_file' do
        subject(:decompress_compressed_dump_file) do
          local_file_system.decompress_compressed_dump_file(table_configuration)
        end

        let(:table_configuration) { local_file_system.load_table_configurations.value!.first }

        let(:sql_file_path) do
          settings.compacted_dump_directory + '/my_schema_name.my_table_name.sql'
        end
        let(:tar_file_path) do
          settings.compacted_dump_directory + '/my_schema_name.my_table_name.sql.tar.gz'
        end

        context do
          before do
            `touch #{tar_file_path}`
            expect(File.exist?(tar_file_path)).to be true
          end

          specify do
            expect(decompress_compressed_dump_file).to be_success
            expect(File.exist?(sql_file_path)).to be true
            expect(File.exist?(tar_file_path)).to be true
          end
        end

        context do
          before do
            `rm #{tar_file_path}`
            expect(File.exist?(tar_file_path)).to be false
          end

          it { is_expected.to be_failure }
        end
      end

      describe '#load_table_configurations' do
        subject(:load_table_configurations) { local_file_system.load_table_configurations }

        specify do
          expect(load_table_configurations).to be_success
          expect(load_table_configurations.value!.first)
            .to be_a SampleDataDump::Entities::TableConfiguration
        end
      end
    end
  end
end
