class BackController < ApplicationController

def index
    # giving me access to the methods in the index view (this is the root view)
  temprature
  sensor_list
  humidity
  samsara_fleet_info
end
# I had to change the gem I was using because getting 
#a response would had made the code bulky. Post requests are good to get safe infromation
# as the the informations is not appended to the URL like a GET request
def  sensor_list
  #this is making a post request to get sensors list
  response = RestClient::Request.new({
      method: :post,
      url:"https://api.samsara.com/v1/sensors/list?access_token=#{Rails.application.credentials.secret_key}",
      payload:{ "groupId": 32780 }.to_json,
      headers: { :accept => :json, content_type: :json }
    }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, (response.to_json) ]
      when 200
        [ :success, (response.to_json) ]
      else
        fail "Invalid response #{response} received."
      end
      # here I setting the body to an elemnet that will be availble in the views.
      @sensor_list = response.body
    end
  end

  def humidity
    #In all of the methods I have used environment variables to keep them safe.
    #here making a post request to get the humidity information.
    response = RestClient::Request.new({
      method: :post,
      url:"https://api.samsara.com/v1/sensors/humidity?access_token=#{Rails.application.credentials.secret_key}",
      payload:{ "groupId": 32780, "sensors": [ 212014918223985], "sensors": [ 212014918280111 ] }.to_json,
      headers: { :accept => :json, content_type: :json }
      }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, (response.to_json) ]
      when 200
        [ :success, (response.to_json) ]
      else
        fail "Invalid response #{response} received."
      end
      #changes string to hash to get the data easier and clearer
      humi_hash = eval(response.body)
      @humidity = humi_hash[:sensors]
    end    
    
  end 

  def temprature
    #here I am making a post request to get the temperature and then saving it in the @temperature variable. 
    response = RestClient::Request.new({
      method: :post,
      url:"https://api.samsara.com/v1/sensors/temperature?access_token=#{Rails.application.credentials.secret_key}",
      payload:{ "groupId": 32780, "sensors": [ 212014918223985], "sensors": [ 212014918280111 ] }.to_json,
      headers: { :accept => :json, content_type: :json }
      }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, (response.to_json) ]
      when 200
        [ :success, (response.to_json) ]
      else
        fail "Invalid response #{response} received."
      end
      #changes string to hash to get the data easier and cleaner
        temp_hash = eval(response.body)
        @temperature = temp_hash[:sensors]
    end    
  end 
  
#I refactored this method below
  def samsara_fleet_info
    #making a get request using Faraday and then parsing the data and setting it to @data
    url = "https://api.samsara.com/v1/fleet/locations?access_token=#{Rails.application.credentials.secret_key}"
    samsara_get(url)
  end

private
  def samsara_get(url)
    @url = "https://api.samsara.com/v1/fleet/locations?access_token=#{Rails.application.credentials.secret_key}"
     @uri = Faraday.get url
    @data = JSON.parse @uri.body
  end
end
