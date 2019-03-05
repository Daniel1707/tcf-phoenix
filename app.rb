require 'sinatra'
require 'redis'
require_relative 'DependencyHelper'
require_relative 'GenerateDocument'

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

  @request_payload['id'] = redis.keys.count

  redis.hset(@request_payload['id'], "test_case", @request_payload.to_json)

  content_type :json
  status 201
  {'testCaseCode': "#{@request_payload['id']}"}.to_json
end

get '/testcase/:id' do
  content_type :json

  id = params["id"]

  response = Database.getData(id)

  content_type :json
  status 200
  response
end

put '/testcase/:id' do
  content_type :json

  id = params["id"]

  @request_payload = JSON.parse request.body.read
  step_number = @request_payload.fetch('stepNumber', nil)
  step_name = @request_payload.fetch('stepName', nil)
  evidence = @request_payload.fetch('evidence', nil)

  lenght = redis.hlen(id)
  step_name =  "step#{lenght.to_s}"

  redis.hmset(id, step_name, @request_payload.to_json)

  content_type :json
  status 201
end

get '/testcase/generateDocument/:id' do
  content_type :json

  id = params["id"]

  documentName = GenerateDocument.create_pdf(id)

  send_file "testCase/#{documentName}", :filename => documentName, :type => 'Application/pdf'

  status 200
end
