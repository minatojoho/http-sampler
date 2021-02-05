class ApplicationController < ActionController::Base
  around_action :global_request_logging

  def global_request_logging
    http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP.*|^X-User.*")}
    http_request_headers = request.headers.env.select{|header_name, header_value| http_request_header_keys.index(header_name)}
    puts '*' * 40
    pp request.method
    pp request.url
    pp request.remote_ip
    pp ActionController::HttpAuthentication::Token.token_and_options(request)
    puts '-' * 40
    http_request_header_keys.each do |key|
      puts ["%20s" % key.to_s, ':', request.headers[key].inspect].join(" ")
    end
    puts '.' * 40
    pp request.raw_post
    puts '-' * 40
    params.keys.each do |key|
      puts ["%20s" % key.to_s, ':', params[key].inspect].join(" ")
    end
    puts '*' * 40
    begin
      yield
    ensure
      puts response.body
    end
  end
end
