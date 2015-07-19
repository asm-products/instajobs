# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/ubuntu/instajobs/"

# Unicorn PID file location
pid "/home/ubuntu/instajobs/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/ubuntu/instajobs/log/unicorn.log"
stdout_path "/home/ubuntu/instajobs/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.instajob.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
