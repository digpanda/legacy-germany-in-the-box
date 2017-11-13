# we make sure all is loaded to get the constants and subclasses
Dir["#{File.dirname(__FILE__)}/../exchange/**/*.rb"].each do |file|
  puts "Loading Exchange File : #{file}"
  load file
end
module WechatBot
  module Exchange
  end
end
