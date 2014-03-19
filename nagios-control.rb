#!/usr/bin/env ruby

require 'optparse'
require 'lib/nagios_session'
require 'lib/nagios_commands'
require 'lib/constants'

options = {}

# Some default values
options[:path] = '/nagios/cgi-bin/cmd.cgi'
options[:protocol] = 'https'
options[:verbose] = false

opts = OptionParser.new do |opts|
  opts.banner = "Usage: nagios-control.rb [options]"
  opts.separator  ""

  opts.on("-s", "--server [HOSTNAME|IP]", String, "Nagios server hostname") do |server|
    options[:server] = server
  end

  opts.on("-U", "--user [USERNAME]", String, "Username to be used when connecting to nagios") do |user|
    options[:user] = user
  end
 
  opts.on("-X", "--password [PASSWORD]", String, "Password to be used when connecting to nagios") do |pw|
    options[:pw] = pw
  end
 
  opts.on("-p", "--protocol [PROTO]", String,  "Protocol to use (http/https)") do |password|
    options[:protocol] = protocol || 'https'
  end

  opts.on("-P", "--path [PATH]", String,  "Path to nagios cmd.cgi") do |path|
    options[:path] = path || '/nagios/cgi-bin/cmd.cgi'
  end

  opts.on("-g","--group [GROUP]", String, "The hostgroup to be used") do |hostgroup|
    options[:hostgroup] = hostgroup
    options[:cmd_type] = 'group'
  end

  opts.on("-h","--host [HOST]", String, "The host to be used") do |host|
    options[:host] = host
    options[:cmd_type] = 'host'
  end

  opts.on("-e","--enable","Enable action") do
    options[:enable] = true
  end

  opts.on("-d","--disable","Disable action") do
    options[:enable] = false
  end
 
  opts.on("-S","--services-notifications","Notifications are enabled|disabled for hosts services") do
    options[:services_notifications] = true
  end

  opts.on("-H", "--hosts-notifications", "Notifications are enabled|disabled for hosts") do
    options[:hosts_notifications] = true
  end

  opts.on("-C", "--services-checks", "Checks of the services are enabled|disabled") do
    options[:services_checks] = true
  end

  opts.on("-v", "--verbose", "Run verbose") do
    options[:verbose] = true
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

# Some checks
raise OptionParser::MissingArgument if options[:enable].nil? or options[:cmd_type].nil? or options[:server].nil? or (options[:services_notifications].nil? and options[:hosts_notifications].nil? and options[:services_checks].nil?)

options.each do |opt,val|
  puts "OPT: #{opt} = #{val}"
end if options[:verbose]

# Initialize the NagiosSession
if options[:user].nil? and options[:pw].nil?
  session = NagiosSession.new(options[:protocol], options[:server], options[:path])
else
  session = NagiosSession.new(options[:protocol], options[:server], options[:path], options[:user], options[:pw])
end

verbose = options[:verbose]
host = options[:host].nil? ? nil : options[:host]
group = options[:hostgroup].nil? ? nil : options[:hostgroup]

case options[:cmd_type]
  when 'host'
    options[:enable] ? send_host_cmd(verbose,HOST_ENABLE_NOTIFICATIONS,host,session) : send_host_cmd(verbose,HOST_DISABLE_NOTIFICATIONS,host,session) if options[:hosts_notifications] == true
    options[:enable] ? send_host_cmd(verbose,HOST_ENABLE_SERVICES_NOTIFICATIONS,host,session) : send_host_cmd(verbose,HOST_DISABLE_SERVICES_NOTIFICATIONS,host,session) if options[:services_notifications] == true
    options[:enable] ? send_host_cmd(verbose,HOST_ENABLE_SERVICES_CHECKS,host,session) : send_host_cmd(verbose,HOST_DISABLE_SERVICES_CHECKS,host,session) if options[:services_checks] == true
  when 'group'
    options[:enable] ? send_group_cmd(verbose,GROUP_ENABLE_HOSTS_NOTIFICATIONS,group,session) : send_group_cmd(verbose,GROUP_DISABLE_HOSTS_NOTIFICATIONS,group,session) if options[:hosts_notifications] == true
    options[:enable] ? send_group_cmd(verbose,GROUP_ENABLE_SERVICES_NOTIFICATIONS,group,session) : send_group_cmd(verbose,GROUP_DISABLE_SERVICES_NOTIFICATIONS,group,session) if options[:services_notifications] == true
    options[:enable] ? send_group_cmd(verbose,GROUP_ENABLE_SERVICES_CHECKS,group,session) : send_group_cmd(verbose,GROUP_DISABLE_SERVICES_CHECKS,group,session) if options[:services_checks] == true
end
