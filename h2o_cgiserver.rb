#!/usr/bin/ruby

require 'webrick'

server = WEBrick::HTTPServer.new :Port => ENV['VCAP_APP_PORT']
server.mount '/', WEBrick::HTTPServlet::FileHandler , './'

class Simple < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    status, content_type, body = do_stuff_with request

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_stuff_with request
    return 200, 'text/plain', 'Invalid filetype'
  end
end

servlet,a,b,c = server.search_servlet('/')
servlet.add_handler("sig",Simple)
servlet.add_handler("txt",Simple)
servlet.add_handler("mojo",Simple)
servlet.add_handler("sh",Simple)
servlet.add_handler("jar",Simple)
servlet.add_handler("jpg",Simple)

trap('INT') { server.stop }
server.start
