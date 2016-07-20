require_relative 'config/db'
require_relative 'models/project'
require_relative 'models/resource'
require_relative 'models/entity'

Entity.destroy_all
Resource.destroy_all
Project.destroy_all

p = Project.create()
r = p.resources.create(title: "users")
r.entities.create(content: {name: "Jesse", age: 27})

puts "end"