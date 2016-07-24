require 'HTTParty'
require 'pry'

base = 'https://stopgap.store/'

describe "resource" do
  before :all do
    res = HTTParty.post(base, headers: {
      "Content-Type": 'application/json'
    })
    @url = base + res["sha"]
  end
  describe "show" do
    it "responds to json w/ json" do
      res = HTTParty.get(@url + "/users", headers: {
	"Content-Type": 'application/json'
      })
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "responds to .json w/ json" do
      res = HTTParty.get(@url + "/users.json")
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "responds to html w/ html" do
      res = HTTParty.get(@url + "/users")
      expect(res.headers["content-type"]).to match("html")
    end
    it "responds to html w/ html" do
      res = HTTParty.get(@url + "/users")
      expect(res.code).to eq(200)
    end
    it "responds to not-yet-existent resources" do
      res = HTTParty.get(@url + "/pizzajams")
      expect(res.code).to eq(200)
    end
  end
  describe "create" do
    it "creates a resouce with a title" do
      res = HTTParty.post(@url, headers:{
	"Content-Type": 'application/json'
      }, body:{title: 'radical-resource'}.to_json)
      expect(res["title"]).to eq("radical-resource")
    end
  end
end
