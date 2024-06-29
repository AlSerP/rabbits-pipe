# Rabbit's Pipe
A simple tool to resend messages from queues. Useful when moving rabbitmq to a new host

## Requirements

Ruby >= 2.3.0

gems:
- bunny (>= 2.6.0)

## Configuration
Specify the sending host and receiving host parameters, as well as the full names of the queues in the config.yml file
```
host_from:
  host: rabbitmq.old
  port: 5432
  user: guest
  password: guest

host_to:
  host: rabbitmq.new
  port: 5432
  user: guest
  password: guest

queues:
  - queue-response-1
  - queue-response-1-error
  - queue-requests-2
  - queue-response-3
```

## Startup
Create configuration file config.yml and run
```
ruby rabbits_pipe.rb
```
