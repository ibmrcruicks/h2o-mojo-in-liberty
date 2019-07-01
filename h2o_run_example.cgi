#!/usr/bin/ruby

require 'cgi'
cgi = CGI.new
puts cgi.header

result=`./h2o_run_demo.sh`
html = "<html><body><pre>" + result + "</pre></body></html>"
print html
