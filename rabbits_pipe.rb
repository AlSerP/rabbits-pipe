require 'bunny'
require 'yaml'

require_relative 'rabbits_pipe/host'
require_relative 'rabbits_pipe/resender'

module RabbitsPipe

end

if __FILE__ == $0
  config = YAML.load_file('config.yml')
  RabbitsPipe::Resender.new(config.inspect)
end
