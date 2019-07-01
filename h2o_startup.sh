#!/bin/bash
cd /app/wlp/usr/servers/defaultServer

PATH=$PATH:/app/.java/jre/bin
export PATH

env >&2

./h2o_cgiserver.rb
