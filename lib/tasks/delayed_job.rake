begin
  gem 'delayed_job', '~>2.0.4'
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "The 'delayed_job' gem is missing. Please install version ~> 2.0.4"
end
