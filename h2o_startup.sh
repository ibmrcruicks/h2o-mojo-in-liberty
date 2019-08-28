#!/bin/bash
cd /app/wlp/usr/servers/defaultServer

PATH=$PATH:/app/.java/jre/bin
export PATH

env >&2

chmod +x h2o_*.rb
chmod +x h2o_*.cgi
chmod +x h2o_*.sh
chmod +x run_example.sh

./h2o_cgiserver.rb
