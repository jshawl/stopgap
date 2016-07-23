require 'httparty'

base = 'http://localhost:4567/'
describe "entity" do
  before :all do
    res = HTTParty.post(base, headers: {
      "Content-Type": 'application/json'
    })
    @url = base + res["sha"]
  end
  describe "index" do
    it "responds w/ json" do
      res = HTTParty.get(@url + "/users", headers: {
	"Content-Type": 'application/json'
      })
      expect(res.headers["content-type"]).to eq("application/json")
    end
  end
  describe "show" do
    it "responds w/ json" do
      res = HTTParty.get(@url + "/users", headers: {
	"Content-Type": 'application/json'
      })
      id = res[-1]["id"]
      res = HTTParty.get(@url + "/users/#{id}", headers: {
	"Content-Type": 'application/json'
      })
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "responds to .json w/ json" do
      res = HTTParty.get(@url + "/users", headers: {
	"Content-Type": 'application/json'
      })
      id = res[-1]["id"]
      res = HTTParty.get(@url + "/users/#{id}.json", headers: { })
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "handles 404 correctly" do
      res = HTTParty.get(@url + "/users", headers: {
	"Content-Type": 'application/json'
      })
      id = -1
      res = HTTParty.get(@url + "/users/#{id}.json", headers: { })
      expect(res.code).to eq(404)
    end
  end

end