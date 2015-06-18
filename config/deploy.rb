set :application, 'SNAP'
set :repo_url, 'https://github.com/STSILABS/open-fda.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# We will tell a white lie to Capistrano
set :scm, :git

# release id is just the commit hash used to create the tarball.
set :project_release_id, `git log --pretty=format:'%h' -n 1 HEAD`
# the same path is used local and remote... just to make things simple for who wrote this.
set :project_tarball_path, "/tmp/#{fetch(:application)}-#{fetch(:project_release_id)}.tar.gz"

# We create a Git Strategy and tell Capistrano to use it, our Git Strategy has a simple rule: Don't use git.
module NoGitStrategy
  def check
    true
  end

  def test
    # Check if the tarball was uploaded.
    test! " [ -f #{fetch(:project_tarball_path)} ] "
  end

  def clone
    true
  end

  def update
    true
  end

  def release
    # Unpack the tarball uploaded by deploy:upload_tarball task.
    context.execute "tar -xf #{fetch(:project_tarball_path)} -C #{release_path}"
    # Remove it just to keep things clean.
    context.execute :rm, fetch(:project_tarball_path)
  end

  def fetch_revision
    # Return the tarball release id, we are using the git hash of HEAD.
    fetch(:project_release_id)
  end
end

# Capistrano will use the module in :git_strategy property to know what to do on some Capistrano operations.
set :git_strategy, NoGitStrategy

# Finally we need a task to create the tarball and upload it,
namespace :deploy do
  desc 'Create and upload project tarball'
  task :upload_tarball do |task, args|
    tarball_path = fetch(:project_tarball_path)
    # This will create a project tarball from HEAD, stashed and not committed changes wont be released.
   `git archive -o #{tarball_path} HEAD`
    raise 'Error creating tarball.'if $? != 0

    on roles(:all) do
      upload! tarball_path, tarball_path
    end
  end
  before "deploy:compile_assets", "deploy:bower_install"
  before "deploy:migrate", "nginx:stop"
  #after "deploy:migrate", "deploy:db_setup"
  after "deploy:published", "deploy:create_app_link"
  after "deploy:finished", "nginx:start"
end

# Attach our upload_tarball task to Capistrano deploy task chain.
before 'deploy:updating', 'deploy:upload_tarball'
set :pty, true

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: [ENV['AWS_KEY']]
}