module RabbitsPipe
  class Host
    attr_reader :host, :port, :user, :password, :durable

    def initialize(config)
      @host = config['host']
      @port = config['port'] || 5432
      @user = config['user'] || 'guest'
      @password = config['password'] || 'guest'
      @durable = config['durable'] || true
    end

    def params
      {
        host: host,
        port: port,
        user: user,
        password: password
      }
    end
  end
end
