task :rg do system “rake test | redgreen” end

   1. test a subset using redgreen on the fly
   2. “rake units” will translate to “rake test:units | redgreen”

rule ”” do |t| system “rake test:#{t.name} | redgreen” end
