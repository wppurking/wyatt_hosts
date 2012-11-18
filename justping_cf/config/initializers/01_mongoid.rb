require "mongoid"
# 根据 VCAP_SERVICES 的环境选择需要初始化的 mongodb id:port;
# 如果是没有 VCAP_SERVICES 的本地环境, 则使用回 mongoid_.yml 文件
Mongoid.configure do |config|
  config.load!(Rails.root.join("config", "mongoid_.yml")) unless ENV['VCAP_SERVICES']
  conn_info = {}


  if ENV['VCAP_SERVICES']
    services = JSON.parse(ENV['VCAP_SERVICES'])
    services.each do |service_version, bindings|
      bindings.each do |binding|
        if binding['label'] =~ /mongo/i
          conn_info = binding['credentials']
          break
        end
      end
    end
    raise "could not find connection info for mongo" unless conn_info
  else
    conn_info = {hostname: '127.0.0.1', port: 27017}
  end

  options = {
      identity_map_enabled: true,
      allow_dynamic_fields: false,
      include_root_in_json: false,
      raise_not_found_error: false
  }

  ip = "#{conn_info[:hostname]}:#{conn_info[:port].to_i}"

  # debug info
  puts "IP: #{ip}"
  puts "DB: #{conn_info['db']}"
  puts "#{conn_info.to_json}"

  # TODO 为什么在这里拿到了正确 cloudfoundry 的 mongodb service 但无法初始化?
  #{"hostname":"172.30.48.68","host":"172.30.48.68","port":25233,"username":"6da5650d-d11f-447d-a88d-73cc9feb9665","password":"1fa1b234-01b2-40ff-96db-5c5afa69cbf1","name":"33ab5652-e536-4d53-bd6a-a101a7c61372","db":"db","url":"mongodb://6da5650d-d11f-447d-a88d-73cc9feb9665:1fa1b234-01b2-40ff-96db-5c5afa69cbf1@172.30.48.68:25233/db"}}
  puts ENV['VCAP_SERVICES']
  sessions = {
      default: {
          database: conn_info['db'] || 'justping',
          hosts: [ip],
          url: conn_info['url']
      }
  }
  if conn_info['username'] and conn_info['password']
    sessions[:default][:username] = conn_info['username']
    sessions[:default][:password] = conn_info['password']
  end


  config.options = options
  config.sessions = sessions
end
