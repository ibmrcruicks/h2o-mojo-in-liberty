#!/usr/bin/ruby
require 'tempfile'
require 'cgi'
cgi = CGI.new

if(cgi.request_method == 'GET')
  result=`./h2o_form_gen.sh`
  print "Content-type: text.html\n\n"
  print "<html><body>"
  print result
  print "</body></html>"
  exit
end

first = true
keys =""
vals=""

cgi.keys.each do | k |
   if(first)
     keys=k
     vals=cgi[k]
     first=false
   else
     keys += "," + k
     vals+="," + cgi[k]
   end
end

f = Tempfile.new('mojo')
f.puts keys
f.puts vals
f.close

result = `./h2o_run_demo.sh pipeline.mojo #{f.path}`
results=result.split(/\n/)
headings=results[0].split(',')
values=results[1].split(',')
count=headings.length


print "Content-type: application/json\n\n"
puts "{"
while (count >0) do
  count-=1
  puts '"' + headings[count] + '":' + values[count]
  if(count >0)
     puts ","
  end
end
puts "}"
