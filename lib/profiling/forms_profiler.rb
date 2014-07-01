post_via_redirect '/', :login => 'admin', :password => 'admin'
say "GET #{path}"

get '/apply_forms'
say "GET #{path}"
