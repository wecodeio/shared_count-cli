# SharedCount::Cli

CLI to the shared_count_api gem

## Installation

    $ gem install shared_count-cli

## Usage

> Note: supports bash globbing

* Redirect the CSV file to stdout

```ruby
$ shared_count-cli ~/Desktop/file?.txt # => ~/Desktop/file1.txt ~/Desktop/file2.txt
```

* Redirect the CSV file to a file

```ruby
$ shared_count-cli ~/Desktop/file?.txt > ~/Desktop/output.csv
```

* Run it in debug mode

```ruby
$ DEBUG=true shared_count-cli ~/Desktop/file?.txt > ~/Desktop/output.csv
$ tail -f shared_count-cli.log
```

* For more fine control see the available command line options

```ruby
$ shared_count-cli --help
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/shared_count-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
