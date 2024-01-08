current_dir = File.expand_path('../../..', __FILE__)
directory current_dir

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)
threads min_threads_count, max_threads_count

worker_timeout 60

bind "unix://#{current_dir}/tmp/sockets/puma.sock"

environment 'production'

pidfile File.expand_path("#{current_dir}/tmp/pids/server.pid")
state_path File.expand_path("#{current_dir}/tmp/pids/puma.state")

stdout_redirect "#{current_dir}/log/puma_access.log", "#{current_dir}/log/puma_error.log", true

workers 2

plugin :tmp_restart
