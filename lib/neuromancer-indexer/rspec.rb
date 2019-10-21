# frozen_string_literal: true

module NeuromancerSpec
  def self.stub
    sqs = Aws::SQS::Client.new(
      region: 'eu-central-1',
      stub_responses: true
    )
    client = Neuromancer::Indexer::Client.new(sqs)
    Neuromancer::Indexer.instance_variable_set('@client', client)
  end

  def self.unstub
    client = Neuromancer::Indexer::Client.new
    Neuromancer::Indexer.instance_variable_set('@client', client)
  end
end
