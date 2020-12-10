# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "my_app_name"
set :repo_url, "git@example.com:me/my_repo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


    # Set the linked directories (Laravel required folders for deployment)
    set :linked_dirs, %w{storage/framework storage/framework/cache storage/framework/views storage/logs}
    append :linked_files, ".env"

    # set :conditionally_migrate, true
    set :keep_releases, 5

    set :pty, true
    set :ssh_options, {:forward_agent => true}

    namespace :deploy do
      task :build do
        on roles(:app) do
          within "#{release_path}" do
            #print "Composing...\n"
            #execute "composer", "install", "--prefer-dist", ">", "/dev/null"
            print "Publishing Vendor...\n"
            execute "php", "artisan", "vendor:publish", "--tag=0"
            print "SETTING CORRECT PERMISSIONS\n"
            execute "chmod", "-Rf", "777", "storage/"
            execute "chmod", "-Rf", "777", "bootstrap/cache"
            print "Autoloading Composer\n"
            execute "composer", "dump-autoload"
            execute "php", "artisan", "storage:link"
            print "MIGRATE\n"
            execute  "php", "artisan", "migrate", "--force"
            execute "php", "artisan", "cache:clear"
            execute "php", "artisan", "config:clear"
            execute "php", "artisan", "view:clear"
            execute "php", "artisan", "route:clear"
            print "BUILD DONE\n"
          end
        end
      end

      before  :finishing, :build

    end

