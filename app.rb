require 'sinatra'
require_relative 'DependencyHelper'

#set :bind, '0.0.0.0'
#set :port, 4569

redis = Redis.new(url: ENV['REDIS_URL'])

get '/testcase/health' do
  content_type :json
  {'response': 'System is up =D'}.to_json
end

post '/testcase/create' do
  content_type :json

  @request_payload = JSON.parse request.body.read

  field_company_name = @request_payload.fetch('companyName', nil)
  field_test_case_name = @request_payload.fetch('testCaseName', nil)
  field_creator = @request_payload.fetch('creator', nil)
  field_project = @request_payload.fetch('project', nil)

  halt(401, { message:"companyName can not be blank"}.to_json) if field_company_name.nil?
  halt(401, { message:"testCaseName can not be blank"}.to_json) if field_test_case_name.nil?
  halt(401, { message:"creator can not be blank"}.to_json) if field_creator.nil?
  halt(401, { message:"team can not be blank"}.to_json) if field_project.nil?

  @request_payload['id'] = redis.llen(:testCase)

  redis.rpush(:testCase, @request_payload.to_json)

  content_type :json
  status 201
  {'response': 'Test case created!', 'testCaseCode': "#{@request_payload['id']}"}.to_json
end

get '/testcase/:id' do
  content_type :json

  id = params["id"]
  halt(404, { message:'Test case not found'}.to_json) if id.to_i >= redis.llen(:testCase)
  redis.lrange(:testCase, id, id)
end
