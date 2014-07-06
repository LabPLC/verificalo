set :environment, 'production'
set :output, 'log/cron.log'
job_type :rake, 'cd :path && :environment_variable=:environment bundle exec rake :task :output'

every [ :sunday, :monday, :tuesday, :wednesday, :thursday ], at: '7am' do
  rake 'verificalo:emails:weekday'
end

every :friday, at: '7am' do
  rake 'verificalo:emails:weekend'
end
