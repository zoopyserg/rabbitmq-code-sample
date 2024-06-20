workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup File.expand_path('../config.ru', __FILE__)
port ENV['PORT'] || 4567
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup
  # For ActiveRecord, establish connection
  # ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
