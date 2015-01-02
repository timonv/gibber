# Gibber

Gibber replaces text with nonsensical latin with a maximum size difference of +/- 30%.

Useful for testing the effects of localization on UI.

[![Build Status](https://travis-ci.org/timonv/gibber.svg?branch=master)](https://travis-ci.org/timonv/gibber)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gibber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gibber

## Usage

```ruby
gibber = Gibber.new
gibber.replace("I have a passion for crooked bananas")
# => A arcu a fringilla nisi tempus venenatis (maybe)
```

Gibber preserves any non wordy characters to give your text that texty feel.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/latin_replace/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
