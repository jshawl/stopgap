require 'httparty'
require 'pry'

base = 'https://stopgap.store/'
describe "entity" do
  before :each do
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
  describe "create" do
    it "responds with json" do
      res = HTTParty.post(@url + '/users.json', follow_redirects: false)
      expect(res.headers["content-type"]).to eq("application/json")
    end
  end
  describe "patch" do
    it "updates" do
      res = HTTParty.post(base, headers: {
	"Content-Type": 'application/json'
      })
      @url = base + res["sha"]
      r = HTTParty.get(@url + "/users.json")
      d = JSON.parse(r.body)
      u = @url + "/users/" + d[-1]["id"].to_s + ".json"
      res = HTTParty.patch(u, body: {name: 'Julia JH'}.to_json, follow_redirects: false)
      d = JSON.parse(res.body)
      expect(d["name"]).to eq("Julia JH")
    end
  end

end