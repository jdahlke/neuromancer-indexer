# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each do
    NeuromancerSpec.stub
  end
end

RSpec.describe Neuromancer::Indexer do
  shared_examples 'raises error' do |error_class, message|
    if message
      it "raises #{error_class}" do
        expect { subject }.to raise_error(error_class, message)
      end
    else
      it "raises #{error_class}" do
        expect { subject }.to raise_error(error_class)
      end
    end
  end

  let(:config) { Neuromancer::Indexer.config }

  describe '.config' do
    it 'should return Configuration' do
      expect(config).to be_kind_of(Neuromancer::Indexer::Configuration)
    end
  end

  describe '.configure' do
    error_class = Neuromancer::Indexer::ConfigurationError

    context 'with empty :region' do
      subject do
        Neuromancer::Indexer.configure do |config|
          config.region = ''
        end
      end

      include_examples 'raises error', error_class
    end

    context 'with empty :sqs_url' do
      subject do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.sqs_url = ''
        end
      end

      include_examples 'raises error', error_class
    end

    context 'with invalid :sqs_url' do
      subject do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.sqs_url = 'http:this-is-not-an-uri'
        end
      end

      include_examples 'raises error', error_class
    end

    context 'with valid values' do
      subject do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.sqs_url = 'https://www.example.com'
        end
      end

      it 'should set configuration' do
        subject

        expect(config.region).to eq('eu-berlin-15')
        expect(config.sqs_url).to eq('https://www.example.com')
      end
    end
  end

  describe '.index' do
    error_class = Neuromancer::Indexer::InvalidDocument

    before do
      Neuromancer::Indexer.configure do |config|
        config.region = 'eu-central-1'
        config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index-test'
      end
    end

    subject do
      described_class.index(obj)
    end

    context 'with valid object' do
      let(:obj) do
        {
          id: 'id-1',
          type: 'objects',
          body: {
            foo: 'bar'
          }
        }
      end

      it 'returns normal SQS response' do
        is_expected.to be_kind_of(Seahorse::Client::Response)
      end
    end

    context 'when obj.id is empty' do
      let(:obj) do
        {
          id: '',
          type: 'objects',
          body: {}
        }
      end

      include_examples 'raises error', error_class, 'document#id is empty'
    end

    context 'when obj.type is empty' do
      let(:obj) do
        {
          id: 'id-1',
          type: '',
          body: {}
        }
      end

      include_examples 'raises error', error_class, 'document#type is empty'
    end

    context 'when obj.body is not a Hash' do
      let(:obj) do
        {
          id: 'id-1',
          type: 'objects',
          body: 'invalid-body'
        }
      end

      include_examples 'raises error', error_class, 'document#body is not a Hash'
    end
  end

  describe '.delete' do
    error_class = Neuromancer::Indexer::InvalidDocument

    before do
      Neuromancer::Indexer.configure do |config|
        config.region = 'eu-central-1'
        config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index-test'
      end
    end

    subject do
      described_class.delete(obj)
    end

    context 'with valid object' do
      let(:obj) do
        {
          id: 'id-1',
          type: 'objects'
        }
      end

      it 'returns normal SQS response' do
        is_expected.to be_kind_of(Seahorse::Client::Response)
      end
    end
  end
end
