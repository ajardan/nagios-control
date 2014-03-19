require 'rubygems'
require 'rest_client'

class NagiosSession
  attr_accessor :proto, :host, :path, :url
  # By default we need to know who we are talking to
  def initialize(proto,host,path,username = nil, password = nil)
    @proto, @host, @path, @username, @password = proto, host, path, username, password
    @url = "#{@proto}://#{@host}#{@path}"
    if @username.nil? and @password.nil?
      @session = RestClient::Resource.new(@url)
    else
      @session = RestClient::Resource.new(@url, :user => @username, :password => @password)
    end
  end

  def post(verb = false, *args)
    resp = @session.post(*args)
    case resp.code
      when 200
        puts "Success"
      else
        puts "Request Failed"
    end if verb == true
  end

  def get(verb = false, *args)
    resp = @session.get(*args)
    case resp.code
      when 200
        puts "Success"
      else
        puts "Request Failed"
    end if verb == true
  end  
end

