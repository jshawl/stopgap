class Resource < ActiveRecord::Base
  belongs_to :project
  belongs_to :entity
  has_many :entities, dependent: :destroy
end
