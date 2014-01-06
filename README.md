# SharedCount::Cli

CLI to the shared_count_api gem

## Installation

    $ gem install shared_count-cli

## Usage

> Note: supports bash globbing

* Redirect the CSV file to stdout

```ruby
$ ruby bin/shared_count-cli ~/Desktop/file?.txt # => ~/Desktop/file1.txt ~/Desktop/file2.txt
```

* Redirect the CSV file to a file

```ruby
$ ruby bin/shared_count-cli ~/Desktop/file?.txt > ~/Desktop/output.csv
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/shared_count-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
