ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'



# Type `rake -T` on your command line to see the available rake tasks.

task :reset do 
  `rm ./db/development.sqlite`
   Rake::Task['db:create'].invoke
   Rake::Task['db:migrate'].invoke
   Rake::Task['db:seed'].invoke
end

   

