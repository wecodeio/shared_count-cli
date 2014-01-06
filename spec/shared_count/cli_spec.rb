require_relative "../spec_helper"

require_relative "../../lib/shared_count/cli"

describe SharedCount::Cli do
  describe ".run" do
    let(:urls) do
      ["http://slashdot.org\n", "http://bbc.co.uk\n", "http://www.lanacion.com.ar\n", "http://www.theguardian.com\n"]
    end

    it "queries the SharedCount API for each URL passed in" do
      csv = SharedCount::Cli.run(urls)

      arr = CSV.parse(csv, headers: :first_row)
      arr[1]["URL"].must_equal "http://slashdot.org"
      arr[2]["URL"].must_equal "http://bbc.co.uk"
      arr[3]["URL"].must_equal "http://www.lanacion.com.ar"
      arr[4]["URL"].must_equal "http://www.theguardian.com"
    end
  end
end
