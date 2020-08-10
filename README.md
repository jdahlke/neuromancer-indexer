# neuromancer-indexer

[![GitHub Actions Test Status](https://github.com/jdahlke/neuromancer-indexer/workflows/Tests/badge.svg?branch=develop)](https://github.com/jdahlke/neuromancer-indexer/actions)

Ruby gem to push data for indexing to the Neuromancer service

### Configuration and Usage

```
Neuromancer::Indexer.configure do |config|
  config.region = 'eu-central-1'
  config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index'

  # optional
  config.access_key_id = 'AWS_ACCESS_KEY_ID'
  config.secret_access_key = 'AWS_SECRET_ACCESS_KEY'
end

Neuromancer::Indexer.index({
  id: 'id-1',
  type: 'objects',
  body: {
    foo: 'foo-string',
    bar: 123,
    baz: ['abc', 'def']
  }
})
```

Stubbing in specs

```
RSpec.configure do |config|
  config.before :each do
    NeuromancerSpec.stub
  end
end
```


### Installation

```
gem 'neuromancer-indexer'

```


### Test

```
bundle exec rake spec
```
