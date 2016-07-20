require_relative '../resources'
class Project < ActiveRecord::Base
  has_many :resources
  before_create :set_hash
  after_create :seed_resources

  private
  def set_hash
    self.sha = Digest::SHA1.hexdigest(Time.now.to_s).slice(0,5)
  end
  def seed_resources
    data.each do |resource, d|
      r = self.resources.create!({title: resource})
      d.each do |datum|
        r.entities.create!(content: datum)
      end
    end
  end
end