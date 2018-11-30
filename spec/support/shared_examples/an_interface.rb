# frozen_string_literal: true

shared_examples_for 'an interface' do
  class Dummy
    def initialize; end
  end

  context 'when all methods raise NotImplementedError' do
    before do
      Dummy.include described_class
    end

    let(:dummy) { Dummy.new }

    specify do
      described_class.instance_methods.each do |method|
        fail_message = "#{method} is not abstract"
        parameters = dummy.method(method).parameters
        if parameters.empty?
          expect { dummy.send(method) }.to raise_error(NotImplementedError), fail_message
        else
          nils = parameters.map { |_| nil }
          expect { dummy.send(method, *nils) }.to raise_error(NotImplementedError), fail_message
        end
      end
    end

    specify do
      filename_match = described_class.name.split('::').last.downcase
      instance_methods = described_class.instance_methods.map do |method_symbol|
        source_location = described_class.instance_method(method_symbol).source_location
        filename = source_location.first.split('/').last.delete('_').gsub('.rb', '')
        next nil unless filename == filename_match

        [method_symbol, source_location.last]
      end.compact.sort_by(&:last).map(&:first)
      expect(instance_methods.length).not_to be_zero
      expect(instance_methods).to eq(instance_methods.sort), 'methods are not in alphabetical order'
    end
  end
end
