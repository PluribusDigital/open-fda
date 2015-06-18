task :setup do 
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> bundle install"
  `bundle install`
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> npm install..."
  `npm install`
  # puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake db:setup"
  # Rake::Task['db:setup'].invoke
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake bower:install"
  Rake::Task['bower:install'].invoke
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake populate_reference"
  Rake::Task['populate_reference'].invoke
end
