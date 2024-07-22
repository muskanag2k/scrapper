task :scan_new do
  MoviesController.keep_check
  puts "checking for the site for any new movie."
end
