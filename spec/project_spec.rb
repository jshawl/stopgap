require 'HTTParty'
require 'pry'

base = 'http://localhost:4567/'
url = base + '00868'

describe "project" do
  before :all do
    res = HTTParty.post(base, headers: {
      "Content-Type": 'application/json'
    })
    @url = base + res["sha"]
  end
  describe "create" do
    it "redirects after creation" do
      res = HTTParty.post(base, follow_redirects: false)
      expect(res.code).to eq(303)
    end
    it "doesn't redirect json requests after creation" do
      res = HTTParty.post(base, headers: {
        "Content-Type": 'application/json'
      }, follow_redirects: false)
      expect(res.code).to eq(200)
    end
  end
  describe "show" do
    it "responds to json with json" do
      res = HTTParty.get(url, headers: {
	'Content-Type': 'application/json'
      })
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "responds to .json with json" do
      res = HTTParty.get(url + ".json")
      expect(res.headers["content-type"]).to eq("application/json")
    end
    it "responds to html w/ html" do
      res = HTTParty.get(url)
      expect(res.headers["content-type"]).to match("text/html")
    end
  end
  describe "delete" do
    it "redirects on html deletion" do
      res = HTTParty.delete(@url, follow_redirects: false)
      expect(res.code).to eq(303)
    end
    it "responds to json with json" do
      res = HTTParty.delete(@url, headers: {
	'Content-Type': 'application/json'
      }, follow_redirects: false)
      expect(res.body).to eq("")
    end
  end
end