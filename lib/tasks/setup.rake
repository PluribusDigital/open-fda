task :setup do 
  puts "1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> bundle install"
  `bundle install`
  puts "2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> npm install..."
  `npm install`
  puts "3a >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake db:setup"
  Rake::Task['db:setup'].invoke
  puts "3b >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake bower:install"
  Rake::Task['bower:install'].invoke
  # puts "3c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> rake pop"
  # Rake::Task['pop'].invoke
end
