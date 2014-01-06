require_relative "../spec_helper"

require_relative "../../lib/shared_count/cli"

describe SharedCount::Cli do
  describe ".run" do
    let(:lines) do
      ["http://slashdot.org\n", "http://bbc.co.uk\n", "http://www.lanacion.com.ar\n", "http://www.theguardian.com\n"]
    end

    it "queries the SharedCount API for each URL passed in" do
      csv = SharedCount::Cli.run(lines)

      arr = CSV.parse(csv, headers: :first_row)
      urls = [arr[1]["URL"], arr[2]["URL"], arr[3]["URL"], arr[4]["URL"]]
      lines.each do |line|
        line.chomp!
        urls.any? { |url| url == line }.must_be_same_as true
      end
    end
  end
end
