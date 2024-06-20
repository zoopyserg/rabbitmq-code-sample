# RabbitMQ Code Sample

## Overview

This repository contains a simple example of using RabbitMQ with a producer and consumer. The application logs messages and uses the ELK stack (Elasticsearch, Logstash, Kibana) for logging and visualization.

## Setup

### Prerequisites

- Docker
- Docker Compose

### Initial Setup

Clone the repository:

```sh
git clone https://github.com/zoopyserg/rabbitmq-code-sample.git
cd rabbitmq-code-sample
```

### Running the Application

Use Docker Compose to set up and start the application:

```sh
docker-compose up --build
```

This will start the following services:
- RabbitMQ (with management console)
- Elasticsearch
- Kibana
- Filebeat
- Sinatra Web Application (Producer)
- Consumer

### Accessing the Services

1. **RabbitMQ Management Console**:
   - URL: `http://localhost:15673`
   - Login: `guest`
   - Password: `guest`

2. **Kibana**:
   - URL: `http://localhost:5601`
   - Use Kibana to visualize the logs.

### Interacting with the Application

1. **Send a Message**:
   - Visit the Sinatra web application to trigger the producer.
   - URL: `http://localhost:4567/produce`
   - This will send a message to the RabbitMQ queue and log the event.

2. **Consumer**:
   - The consumer will automatically consume messages from the RabbitMQ queue and log the event.

### Verifying Logs in Kibana

1. Open Kibana at `http://localhost:5601`.
2. Navigate to **Stack Management** > **Index Patterns**.
3. Create an index pattern for `filebeat-*`.
4. Go to **Discover** and select the `filebeat-*` index pattern to view logs.

### Manual Testing

To manually run the producer and consumer without Docker:

1. **Start RabbitMQ**:

```sh
docker run --rm --name rabbitmq -p 5672:5672 -p 15672:15672 --hostname rabbitmq -v rabbitmq:/var/lib/rabbitmq rabbitmq:3-management
```

2. **Run Producer**:

```sh
ruby producer.rb
```

3. **Run Consumer**:

```sh
ruby consumer.rb
```
