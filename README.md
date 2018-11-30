# Sample Data Dump

This gem provides:
  - Use cases for sample data dump utility
  - Persistence interface for sample data dump utility

## Usage

1. Create a class that implements the persistence interface.
2. Pass it to the appropriate use case.
3. Use the result to take your next action.

```
SampleDataDump::UseCases::ActorDownloadsSampleDataFiles.new(persistence).result
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sample_data_dump', git: 'git@github.com:tricycle/sample_data_dump.git'
```

And then execute:

    $ bundle install
