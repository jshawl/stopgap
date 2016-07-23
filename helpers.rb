helpers do
  def url
    protocol = request.env['HTTP_HOST'] == "localhost:4567" ? 'http' : 'https'
    "#{protocol}://#{request.env['HTTP_HOST']}#{request.path}".gsub(/\?(.*)/,'')
  end
  def path
    request.path[1..-1]
  end
  def method
    m = params[:method] || 'GET'
    m.upcase
  end
  def singularize str
    str.gsub(/s$/,'')
  end
  def link path
    paths = path.split("/")
    psofar = ''
    paths.map{|p|
      psofar += "/" + p
      "<a href='#{psofar}'>#{p}</a>"
    }.join("/")
  end
end
