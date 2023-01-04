#!/bin/bash

TOTAL_ARG_COUNT=$#

show_usage(){
    echo "Usage $0 [-<action>]"
    echo ""
    echo "      -start_zookeeper:          Start the zookeeper"
    echo "      -start_k_server:           Start the kafka server"
    echo "      -create_topic [NAME]       Create a topic with the specified NAME"
    echo "      -create_producer [NAME]    Create a console for producing messages on topic NAME"
    echo "      -create_consumer [NAME]    Show consumed message of a topic from beginning"

}

if [ $TOTAL_ARG_COUNT -lt 1 ]
then
   show_usage
   exit 1
fi

START_ZOOKEEPER=0
START_KAFKA_SERVER=0
CREATE_TOPIC=0
CREATE_PRODUCER=0
CREATE_CONSUMER=0
TOPIC=""
KAFKA_HOME=$(pwd)/kafka_2.12-3.3.1/

while [[ $# > 0 ]]
do
    case $1 in
        -start_zookeeper) START_ZOOKEEPER=1 ;;
        -start_k_server) START_KAFKA_SERVER=1 ;;
        -create_topic) shift; TOPIC=$1; CREATE_TOPIC=1 ;;
        -create_producer) shift; TOPIC=$1; CREATE_PRODUCER=1 ;;
        -create_consumer) shift; TOPIC=$1; CREATE_CONSUMER=1 ;;
        -h | --help) show_usage ;;
        *)
            echo -e "Error: Invalid Option $1\n"
            show_usage ;;
    esac
    shift
done

check_topic(){
    local TOPIC_NAME=$1
    if [ -z "$TOPIC_NAME" ]
    then 
        echo -e "Topic name cannot be blank"
        show_usage
        exit 1
    fi
}

if [ $START_ZOOKEEPER -eq 1 ]
then
    $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
fi

if [ $START_KAFKA_SERVER -eq 1 ]
then
    $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
fi


if [ $CREATE_TOPIC -eq 1 ]
then
    check_topic $TOPIC
    $KAFKA_HOME/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --if-not-exists --replication-factor 1 --partitions 1 --topic $TOPIC
fi

if [ $CREATE_PRODUCER -eq 1 ]
then
    check_topic $TOPIC
    $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic $TOPIC
fi

if [ $CREATE_CONSUMER -eq 1 ]
then
    check_topic $TOPIC
    $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic $TOPIC --from-beginning 
fi