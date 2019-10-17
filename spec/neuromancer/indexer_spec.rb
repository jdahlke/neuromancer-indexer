# frozen_string_literal: true

RSpec.describe Neuromancer::Indexer do
  let(:config) { Neuromancer::Indexer.config }

  describe '.config' do
    it 'should return Configuration' do
      expect(config).to be_kind_of(Neuromancer::Indexer::Configuration)
    end
  end

  describe '.configure' do
    let(:error_class) { Neuromancer::Indexer::ConfigurationError }

    context 'with empty :region' do
      let (:configure) do
        Neuromancer::Indexer.configure do |config|
          config.region = ''
        end
      end

      it 'should raise error' do
        expect { configure }.to raise_error(error_class)
      end
    end

    context 'with empty :sqs_url' do
      let (:configure) do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.sqs_url = ''
        end
      end

      it 'should raise error' do
        expect { configure }.to raise_error(error_class)
      end
    end

    context 'with invalid :sqs_url' do
      let (:configure) do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.sqs_url = 'http:this-is-not-an-uri'
        end
      end

      it 'should raise error' do
        expect { configure }.to raise_error(error_class)
      end
    end

    context 'with valid values' do
      let (:configure) do
        Neuromancer::Indexer.configure do |config|
          config.region = 'eu-berlin-15'
          config.stage = 'test'
          config.sqs_url = 'https://www.example.com'
        end
      end

      it 'should set configuration' do
        configure

        expect(config.region).to eq('eu-berlin-15')
        expect(config.stage).to eq('test')
        expect(config.sqs_url).to eq('https://www.example.com')
      end
    end
  end

  describe '.index' do
    let(:error_class) { Neuromancer::Indexer::Error }
    let(:indexer) { Neuromancer::Indexer }

    before do
      Neuromancer::Indexer.configure do |config|
        config.region = 'eu-central-1'
        config.stage = 'test'
        config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index-test'
      end

      # stub SQS client
      client = indexer.instance_variable_get('@client')
      sqs_stub = Aws::SQS::Client.new(
        region: 'eu-central-1',
        stub_responses: true
      )
      client.instance_variable_set('@sqs', sqs_stub)
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
        expect(indexer.index(obj)).to be_kind_of(Seahorse::Client::Response)
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

      it 'raise an error' do
        expect { indexer.index(obj) }.to raise_error(error_class, 'Key `id` in obj cannot be empty')
      end
    end

    context 'when obj.type is empty' do
      let(:obj) do
        {
          id: 'id-1',
          type: '',
          body: {}
        }
      end

      it 'raise an error' do
        expect { indexer.index(obj) }.to raise_error(error_class, 'Key `type` in obj cannot be empty')
      end
    end

    context 'when obj.body is not a Hash' do
      let(:obj) do
        {
          id: 'id-1',
          type: 'objects',
          body: 'invalid-body'
        }
      end

      it 'raise an error' do
        expect { indexer.index(obj) }.to raise_error(error_class, 'Key `body` must be a Hash')
      end
    end
  end
end
