require 'digest'
require 'fileutils'
require 'net/http'
require 'net/https'
require 'tempfile'
require 'pry'

namespace :njt do

  BASE_URI = URI('https://www.njtransit.com/mt/mt_servlet.srv')

  desc "Grab a session ID at the NJ Transit developer site"
  task :begin_session => :environment do
    uri = BASE_URI.clone
    uri.query = URI.encode_www_form(:hdnPageAction => 'MTDevLoginTo')

    $http = Net::HTTP.new(uri.host, uri.port)
    $http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    response = $http.start { |connection| connection.request(request) }

    $session_id = response['set-cookie'].to_s[/JSESSIONID=([^;]+);/, 1]
  end

  desc "Login in to the NJ Transit developer site with the grabbed session ID"
  task :login => :begin_session do
    uri = BASE_URI.clone
    uri.query = URI.encode_www_form(:hdnPageAction => 'MTDevLoginSubmitTo')

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Cookie'] = "JSESSIONID=#{$session_id}"
    request.set_form_data(
      'userName' => ENV['NJT_DEVELOPER_USERNAME'],
      'password' => ENV['NJT_DEVELOPER_PASSWORD']
    )

    response = $http.start { |connection| connection.request(request) }
  end

  desc "Download zip of Rail GTFS data"
  task :download_rail_gtfs => :login do
    uri = BASE_URI.clone
    uri.query = URI.encode_www_form(
      :hdnPageAction => 'MTDevResourceDownloadTo',
      :Category => 'rail'
    )

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Cookie'] = "JSESSIONID=#{$session_id}"

    response = $http.start { |connection| connection.request(request) }

    temp_file = Tempfile.new('gtfs-rail')
    File.open(temp_file.path, 'wb') { |f| f.write response.body }
    raise "GTFS failed to parse downloaded zip" unless validate_zip(temp_file.path)
    downloaded_hash = Digest::SHA1.file(temp_file.path).hexdigest

    GTFS_NJT_RAIL_ROOT = File.join(Rails.root.to_s, 'var', 'gtfs', 'njt', 'rail')

    current_gtfs_path = File.join(GTFS_NJT_RAIL_ROOT, 'current.zip')
    current_hash = Digest::SHA1.file(current_gtfs_path).hexdigest

    reload_data = false
    unless current_hash.eql?(downloaded_hash)
      today = CalendarDate.today.id.to_s
      date = [today[0..3], today[4..5], today[6..7]].join('-')

      version_path = File.join(GTFS_NJT_RAIL_ROOT, 'versions', "#{date}.zip")
      FileUtils.cp temp_file.path, version_path
      # The force option allows us to avoid deleting the existing symlink.
      # FileUtils.rm_f current_gtfs_path
      FileUtils.ln_s version_path, current_gtfs_path, :force => true

      reload_data = true
    end

    temp_file.close

    Rake::Task['gtfs:all'].invoke if reload_data
  end

  def validate_zip(path)
    begin
      GTFS::Source.build path
      return true
    rescue
      return false
    end
  end
end

