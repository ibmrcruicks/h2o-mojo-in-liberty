#!/bin/bash

echo '<form action=./h2o_mojo.cgi method=post><input type=submit><br>'
#echo `head -1 ./example.csv | sed -e 's/\([^\,]*\)[,]*/\1 : \<input id=mojotype=text name=\1\>\<br\>/g'`
echo `head -2 ./example.csv | awk  'BEGIN { PROCINFO["sorted_in"] = "@ind_num_asc"; }\
          { split($0,keys, ",");if(getline >0) {\
              max = split($0,values,","); \
              print "<table>";\
              for (i=1; i <= max; i++) {\
                print "<tr><td>" keys[i] " : </td><td><input type=text name=" keys[i] " value="  values[i] "></td></tr>"\
              };\
              print "</table>";\
            }\
          }'`
echo '<br><input type=submit></form>'
