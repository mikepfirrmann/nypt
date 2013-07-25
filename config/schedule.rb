# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

%w{NYPT_DB_PASSWORD NJT_DEVELOPER_USERNAME NJT_DEVELOPER_PASSWORD}.each do |name|
  env name, ENV[name]
end

every 4.minutes do
  rake(
    'nypt:save_departures',
    :environment => 'development',
    :output => {
      :standard => '/var/log/nypt/save_departures.stdout',
      :error => '/var/log/nypt/save_departures.stderr',
    }
  )
end

every :day, :at => '9:00am' do
  rake(
    'njt:download_rail_gtfs',
    :environment => 'development',
    :output => {
      :standard => '/var/log/nypt/download_rail_gtfs.stdout',
      :error => '/var/log/nypt/download_rail_gtfs.stderr',
    }
  )
end
