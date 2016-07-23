require 'HTTParty'
require 'pry'

base = 'http://localhost:4567/'

describe "resource" do
  before :all do
    res = HTTParty.post(base, headers: {
      "Content-Type": 'application/json'
    })
    @url = base + res["sha"]
  end
end
