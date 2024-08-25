#!/bin/bash

# Start the containers
sh $([ -f sail ] && echo sail || echo vendor/bin/sail) up -d

# Wait for MySQL to initialize
echo "Waiting for MySQL to initialize..."
sleep 15

# Configure the master
echo "Configuring MySQL master..."
docker exec mysql-master mysql -uroot -psecret -e "SET GLOBAL log_bin = 'mysql-bin';"
docker exec mysql-master mysql -uroot -psecret -e "SET GLOBAL server_id = 1;"
docker exec mysql-master mysql -uroot -psecret -e "CREATE USER IF NOT EXISTS 'app'@'%' IDENTIFIED WITH mysql_native_password BY 'secret';"
docker exec mysql-master mysql -uroot -psecret -e "GRANT REPLICATION SLAVE ON *.* TO 'app'@'%';"
MASTER_STATUS=$(docker exec mysql-master mysql -uroot -psecret -e "SHOW MASTER STATUS\G")
LOG_FILE=$(echo "$MASTER_STATUS" | grep 'File:' | awk '{print $2}')
LOG_POS=$(echo "$MASTER_STATUS" | grep 'Position:' | awk '{print $2}')

# Configure the slave
echo "Configuring MySQL slave..."
docker exec mysql-slave mysql -uroot -psecret -e "SET GLOBAL server_id = 2;"
docker exec mysql-slave mysql -uroot -psecret -e "STOP SLAVE;"
docker exec mysql-slave mysql -uroot -psecret -e "RESET SLAVE ALL;"
docker exec mysql-slave mysql -uroot -psecret -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='app', MASTER_PASSWORD='secret', MASTER_LOG_FILE='$LOG_FILE', MASTER_LOG_POS=$LOG_POS;"
docker exec mysql-slave mysql -uroot -psecret -e "START SLAVE;"

# Verify replication
SLAVE_STATUS=$(docker exec mysql-slave mysql -uroot -psecret -e "SHOW SLAVE STATUS\G")
SLAVE_IO_RUNNING=$(echo "$SLAVE_STATUS" | grep 'Slave_IO_Running:' | awk '{print $2}')
SLAVE_SQL_RUNNING=$(echo "$SLAVE_STATUS" | grep 'Slave_SQL_Running:' | awk '{print $2}')

if [[ "$SLAVE_IO_RUNNING" == "Yes" && "$SLAVE_SQL_RUNNING" == "Yes" ]]; then
  echo "MySQL replication setup successfully!"
else
  echo "MySQL replication setup failed!"
fi
