require_relative '../DependencyHelper'

class Request
  attr_accessor :body, :code, :detail

  def self.send_post(header, request_url, body, env)

    @headers = {}

    header.each do |key, value|
      @headers[key] = value
    end

    begin
      response = RestClient.post env + request_url, body.to_json, @headers
    rescue Exception => detail
      response = detail.response
    ensure
      if response.body.empty?
        return { body: '', code: response.code, detail: response }
      end
      return { body: JSON.parse(response.body), code: response.code, detail: response }
    end
  end
end
