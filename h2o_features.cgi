#!/usr/bin/ruby
require 'cgi'
cgi = CGI.new
puts cgi.header

result=`head -1 ./example.csv`
html = "<html><body><pre>" + result + "</pre></body></html>"
print html
