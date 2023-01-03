# KAFKA Basics


### Starting Zookeeper
- `bin/zookeeper-server-start.sh config/zookeeper.properties`


### Starting Kafka Server

- `bin/kafka-server-start.sh config/server.properties`


### Creating a Topic

- `bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test`

TO list the topics

- `bin/kafka-topics.sh --list --bootstrap-server localhost:9092`


### Sending messages

- `bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test`

you will see a prompt where you can write your message

### Viewing the logs/messages

- `bin/kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration --print-data-log --files /tmp/kafka-logs/test-0/00000000000000000000.log`

### Consuming messages

- `bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning`
