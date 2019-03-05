require 'redis'
require_relative 'DependencyHelper'

class Database
  @redis = Redis.new(url: ENV['@redis_URL'])

  def self.getData(id)
    lenght = @redis.hlen(id) - 1
    i = 1

    response = "[#{@redis.hget(id, "test_case")}"

    if @redis.hget(id, "step" + lenght.to_s) != nil
      while i <= lenght  do
        response = "#{response},#{@redis.hget(id, "step#{i.to_s}")}"
        i +=1
      end
    end

    response = "#{response}]"
  end
end
