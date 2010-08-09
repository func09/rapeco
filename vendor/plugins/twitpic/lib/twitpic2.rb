require "net/https"
require "uri"
require 'mime/types'
require 'json'

class TwitPic2
  VERSION = '0.0.1'

  class APIError < StandardError; end

  def initialize(api_key, consumer_key, consumer_secret)
    @api_key, @consumer_key, @consumer_secret = api_key, consumer_key, consumer_secret
  end

  def upload(file_path, oauth_token, oauth_secret, message = nil, boundary = "----------------------------TwitPic#{rand(1000000000000)}")
    parts = {
      :key => @api_key,
      :consumer_token => @consumer_key,
      :consumer_secret => @consumer_secret,
      :oauth_token => oauth_token,
      :oauth_secret => oauth_secret,
    }
    parts[:message] = message if message && !message.empty?

    body = create_body(parts, file_path, boundary)

    url = 
      if parts[:message]
        'http://api.twitpic.com/1/uploadAndPost.json'
      else
        'http://api.twitpic.com/1/upload.json'
      end

    post(url, body, boundary)
  end

  def post(url, body, boundary)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    json = http.start do |http|
      headers = {"Content-Type" => "multipart/form-data; boundary=" + boundary}
      response = http.post(uri.path, body, headers)
      
      case response.code
      when "200"
      when "400"
        raise APIError, "Bad Request"
      when "401"
        raise APIError, "Unauthorized"
      else
        raise APIError, "Other Error"
      end
      
      response.body
    end
    parse_response(json)
  end

  def parse_response(json)
    JSON.parse(json)
  end

  def content_type(file_path)
    type = MIME::Types.type_for(file_path).first
    if type
      type.content_type
    else
      'image/png'
    end
  end

  def create_body(parts, file_path, boundary)
    parts[:media] = open(file_path, 'rb').read
    body = ''
    [:media, :key, :consumer_token, :consumer_secret, :oauth_token, :oauth_secret, :message].each do |key|
      value = parts[key]
      next unless value
      body << "--#{boundary}\r\n"
      if key == :media
        body << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{File.basename(file_path)}\"\r\n"
        body << "Content-Type: #{content_type(file_path)}\r\n"
      else
        body << "Content-Disposition: form-data; name=\"#{key}\"\r\n"
      end
      body << "\r\n"
      body << "#{value}\r\n"
    end
    body << "--#{boundary}--\r\n"
  end
end
