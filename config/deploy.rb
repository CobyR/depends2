fail_message = "\nInvalid deploy_env specified\n\tUsage: cap {command} -S deploy_env={environment}\nReview config\deploy.rb to see what environments are currently defined.\n\n"

# default to integrtion deploy if no environment specified
begin; deploy_env; rescue NameError; set :deploy_env, 'integration' end

set :application, "depends2"

set :user, 'g5search'
set :use_sudo, false

# version control config
set :scm, 'git'
set :repository,  "git@github.com:CobyR/depends2"
set :branch, 'master'

set :deploy_via, :copy

set :home_dir, "/data"

case deploy_env
when 'integration'
  role :web, 'uranus.g5search.com'
  role :app, 'uranus.g5search.com'
else
  puts fail_message
  exit
end

set :application_dir, "#{home_dir}/#{application}"
set :deploy_to, application_dir

# NewRelic deployment notification
after 'deploy:update', 'newrelic:notice_deployment'

after 'deploy', 'deploy:cleanup'

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
  end
end
