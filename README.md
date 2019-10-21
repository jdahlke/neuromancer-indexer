# neuromancer-indexer

[![Build Status](https://travis-ci.com/jdahlke/neuromancer-indexer.svg?branch=develop)](https://travis-ci.com/jdahlke/neuromancer-indexer)

Ruby gem to push data for indexing to the Neuromancer service

### Configuration and Usage

```
Neuromancer::Indexer.configure do |config|
  config.region = 'eu-central-1'
  config.sqs_url = 'https://sqs.eu-central-1.amazonaws.com/1234567890/neuromancer-index'
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
