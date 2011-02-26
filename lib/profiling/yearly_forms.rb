post_via_redirect '/', :login => 'admin', :password => 'admin'
say "GET #{path}"

def browse(path, params)
  get path, params
  say "GET #{path}"
end


# and browse these
browse '/apply_forms', { :year => 2008, :state => 'all' }
browse '/apply_forms', { :year => 2007, :tag_id => Tag.first.id }
browse '/apply_forms', { :year => 2007, :state => 'accepted' }



