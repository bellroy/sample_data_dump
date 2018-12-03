# Sample Data Dump

This gem provides:
  - Use cases for sample data dump utility
  - Persistence interface for sample data dump utility

## Usage

1. Create a class that implements the CompressedDumpStorageGateway interface.
2. Create a class that implements the DataStoreGateway interface.
3. Initialize your gateway classes and a Settings class.
4. Pass the gateways and settings to the appropriate command.
5. Use the result to take your next action.

```
settings = SampleDataDump::Settings.new(
  compacted_dump_directory: '/tmp/compacted_dumps',
  config_file_path: 'config/sample_data_dump.yml'
)
local_file_system = SampleDataDump::Gateways::LocalFileSystem.new(settings)
s3_storage = AmazonS3CompressedDumpStorageGateway.new(my_amazon_settings)
postgres_db = PostgresDataStoreGateway.new(my_postgres_settings)

SampleDataDump::Commands::DownloadCompressedDataDumps.new(local_file_system, s3_storage, settings).result.bind do
  SampleDataDump::Commands::DecompressAndLoadSampleDataDumps.new(local_file_system, postgres_db, settings).result
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sample_data_dump', git: 'git@github.com:tricycle/sample_data_dump.git'
```

And then execute:

    $ bundle install
