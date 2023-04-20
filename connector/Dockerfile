FROM debezium/connect:latest

# from https://www.confluent.io/hub/confluentinc/kafka-connect-jdbc
RUN curl -LO https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-jdbc/versions/10.7.0/confluentinc-kafka-connect-jdbc-10.7.0.zip
RUN unzip confluentinc-kafka-connect-jdbc-10.7.0.zip -d /kafka/connect
RUN rm confluentinc-kafka-connect-jdbc-10.7.0.zip

# from https://dev.mysql.com/downloads/connector/j/
RUN curl -LO https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.0.32.zip
RUN unzip mysql-connector-j-8.0.32.zip
RUN mv ./mysql-connector-j-8.0.32/mysql-connector-j-8.0.32.jar /kafka/libs/mysql-connector-j-8.0.32.jar
RUN rm mysql-connector-j-8.0.32.zip
RUN rm -rf mysql-connector-j-8.0.32
