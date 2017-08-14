root = "/home/tranthuc/apps/ocean_deploy_test/"
working_directory root
#pid của unicorn khi chạy
pid "#{root}/tmp/pids/unicorn.pid"
#log
stderr_path "#{root}/log/unicorn.error.log"
stdout_path "#{root}/log/unicorn.access.log"

#chạy với sock
listen "#{root}/shared/sockets/unicorn.sock"
worker_processes 2
timeout 30
