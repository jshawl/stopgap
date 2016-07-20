def link path
  paths = path.split("/")
  psofar = ''
  paths.map{|p|
    psofar += "/" + p
    "<a href='#{psofar}'>#{p}</a>"
  }.join("/")
end

p link("users") #== "/<a href='/users'>users</a>"
p link("users/1") #== "/<a href='/users'>users</a>"