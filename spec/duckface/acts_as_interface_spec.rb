# frozen_string_literal: true

require 'duckface'
require_relative '../support/shared_examples/an_interface'
Dir["#{File.dirname(__FILE__)}/../../lib/**/*.rb"].each { |file| require file }

module Duckface
  describe ActsAsInterface do
    ObjectSpace.each_object(Duckface::ActsAsInterface).each do |interface|
      describe interface do
        it_behaves_like 'an interface'
      end
    end
  end
end
