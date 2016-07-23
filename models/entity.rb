class Entity < ActiveRecord::Base
  belongs_to :resource
  has_many :resources
  def as_json(options={})
    attrs = {url: "https://stopgap.store/#{self.resource.project.sha}/#{self.resource.title}/#{self.id}"}
    self.content.each do |k, v|
      attrs[k] = v
    end
    super(except: [:content, :resource_id]).merge(attrs)
  end
end
