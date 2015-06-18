namespace :deploy do

  desc "Create symbolic link for nginx app folder"
  task :create_app_link do
    on roles(:app) do
      execute "if test ! -d /var/www/app; then ln -s /var/www/#{fetch(:application)} /var/www/app; else echo 0; fi"
    end
  end
  
  desc "Install Bower"
  task :bower_install do
    on roles(:app) do
      within fetch(:release_path) do
	    execute :rake, "bower:install"
      end
	end
  end

end