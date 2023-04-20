# Kafka CDC test with docker compose

This is a simple test to show how to use Kafka CDC with docker compose.

This is a test code for CDC for DB backup in MySQL to MySQL.

## How to use

### 1. Start docker compose

```zsh
docker-compose -f ./docker-compose-distributed.yml up -d

# or for single mode
docker-compose -f ./docker-compose-single.yml up -d
```

### 2. Set Connector by REST API

Since Kafka Connect uses Rest API, the json below must be sent as the body.<br>
You can use Postman or curl command.

<b>Source Connector</b>

POST: localhost:8083/connectors

```json
{
  "name": "testdb-connector",  
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "mysqluser",
    "database.password": "mysqlpw",
    "database.server.id": "184054",
    "topic.prefix": "dbserver1",
    "database.include.list": "testdb", 
    "database.allowPublicKeyRetrieval":"true", 
    // "schema.history.internal.kafka.bootstrap.servers": "kafka:9092", for single mode
    "schema.history.internal.kafka.bootstrap.servers": "kafka1:9092,kafka2:9092,kafka3:9092",
    "schema.history.internal.kafka.topic": "schema-changes.testdb"  
  }
}
```

![Screenshot from 2023-04-20 10-03-59](https://user-images.githubusercontent.com/20539422/233231369-4d72506c-f3d1-413e-91e0-007653f9389a.png)


<b>Sink Connector</b>

POST: localhost:8083/connectors

```json
{
    "name": "sink-testdb-connector",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "connection.url": "jdbc:mysql://sink-mysql:3306/testdb",
        "connection.user": "mysqluser",
        "connection.password": "mysqlpw",
        "auto.create": "false",
        "auto.evolve": "false",
        "delete.enabled": "true",
        "insert.mode": "upsert",
        "pk.mode": "record_key",
        "metadata.max.age.ms": 60000,
        "topics.regex": "dbserver1.testdb.(.*)",
        "table.name.format": "${topic}",
        "tombstones.on.delete": "true",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "true",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": "true",
        "transforms": "unwrap,route,TimestampConverter",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones": false,
        "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
        "transforms.route.replacement": "$3",
        "transforms.TimestampConverter.type": "org.apache.kafka.connect.transforms.TimestampConverter$Value", 
        "transforms.TimestampConverter.format": "yyyy-MM-dd HH:mm:ss", 
        "transforms.TimestampConverter.target.type": "Timestamp", 
        "transforms.TimestampConverter.field": "update_date"
    }
}
```

![Screenshot from 2023-04-20 10-04-14](https://user-images.githubusercontent.com/20539422/233231312-c5ba293d-c8a9-4e68-896b-d745933fcfa0.png)

## Reference

<https://debezium.io/blog/2017/09/25/streaming-to-another-database/>

<https://debezium.io/documentation/reference/2.1/tutorial.html>

<https://debezium.io/documentation/reference/stable/transformations/event-flattening.html>

<https://docs.confluent.io/kafka-connectors/jdbc/current/sink-connector/overview.html>
