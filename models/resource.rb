class Resource < ActiveRecord::Base
  belongs_to :project
  has_many :entities
end
