#!/usr/bin/env puma

bind 'tcp://128.199.36.58:9090'
stdout_redirect 'log/puma.log', 'log/puma_error.log', true

#port 8080
#environment 'sandbox'
# pidfile 'tmp/pids/puma.pid'
# state_path 'tmp/pids/puma.state'
# daemonize true
# workers 4
