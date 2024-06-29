module RabbitsPipe
  class Resender
    def initialize(config)
      @host_from = RabbitsPipe::Host.new(config['host_from'])
      @host_to = RabbitsPipe::Host.new(config['host_to'])
      @queues = config['queues']

      @current_queue = nil
    end
  
    def run
      queues.each do |queue_name|
        resend_queue(queue_name)
      end
    end

    private

    attr_reader :host_from, :host_to, :queues, :current_queue

    def resend_queue(queue_name)
      @current_queue = queue_name
      logger.info "Start resending messages from '#{queue_name}'"

      # Connect to host's queues
      connection_from, queue_from = connect(host_from)
      connection_to, queue_to = connect(host_to)

      # Resending messages to another host
      while queue_from.message_count > 0
        delivery_info, properties, payload = queue_from.pop
        logger.info "[x] Get a message from, '#{queue_from.message_count}' messages left"
        channel_to.default_exchange.publish(payload, routing_key: queue_to.name)
        logger.info "[x] Sent to #{queue_to.name}"
      end

      # Close connections
      connection_from.close
      connection_to.close
      @current_queue = nil

      logger.info "Done with #{queue_name}"
    end

    def connect(host)
      connection = Bunny.new(**host.params, automatically_recover: false)
      connection.start
      channel = connection.create_channel
      queue = channel.queue(current_queue, durable: host.durable)

      logger.info "Connected to #{queue_name} of #{host.host}"

      [connection, queue]
    end

    def logger
      @logger ||= Logger.new File.open(File.join(tmp, 'log/main.log', 'w'))
    end
  end
end
