# neuromancer-indexer

[![GitHub Actions Test Status](https://github.com/jdahlke/neuromancer-indexer/workflows/Tests/badge.svg?branch=develop)](https://github.com/jdahlke/neuromancer-indexer/actions)

Ruby gem to push data for indexing to the Neuromancer service.


### Getting started

Configuration

```
Neuromancer::Indexer.configure do |config|
  config.region = 'eu-central-1'
  config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index'

  # optional
  config.access_key_id = 'AWS_ACCESS_KEY_ID'
  config.secret_access_key = 'AWS_SECRET_ACCESS_KEY'
end
```

Indexing objects

```
Neuromancer::Indexer.index(
  id: 'id-1',
  type: 'objects',
  attributes: {
    foo: 'foo-string',
    bar: 123,
    baz: ['abc', 'def']
  }
)
```

Deleting objects

```
Neuromancer::Indexer.delete(
  id: 'id-1',
  type: 'objects'
)
```

Stubbing in Specs

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
bundle exec rspec spec
```
