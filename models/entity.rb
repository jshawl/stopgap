class Entity < ActiveRecord::Base
  belongs_to :resource
  def as_json(options={})
    attrs = {}
    self.content.each do |k, v|
      attrs[k] = v
    end
    super(except: [:content, :resource_id]).merge(attrs)
  end
end
