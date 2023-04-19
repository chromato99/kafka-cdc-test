create database testdb; 
use testdb; 
CREATE TABLE accounts ( 
    account_id VARCHAR(255), 
    role_id VARCHAR(255), 
    user_name VARCHAR(255), 
    user_description VARCHAR(255), 
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY (account_id) 
);

GRANT ALL PRIVILEGES ON *.* TO 'mysqluser'@'%';