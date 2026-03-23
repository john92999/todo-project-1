steps to install it manually

Mongo installation

```
sudo apt-get install -y curl

curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo systemctl start mongod

sudo systemctl enable mongod

sudo systemctl status mongod

```

Java Installation

```
sudo apt-get update

sudo apt-get install -y openjdk-11-jdk

java -version

```

Installing Maven

```
sudo apt-get install -y maven

```

Installing Node.js

```

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -

sudo apt-get install -y nodejs

node -v

npm -v

```

setup Mongodb

```
mongosh

use admin
db.createUser({ user: "root", pwd: "password", roles: [{ role: "root", db: "admin" }] })
use todo
db.createCollection("todos")
exit

```

Enable Mongodb authentication

```
sudo nano /etc/mongod.conf

security:
  authorization: enabled

sudo systemctl restart mongod
sudo systemctl status mongod

```

Install git and clone the repositories

```
sudo apt update -y

sudo apt install git -y

git clone https://github.com/pelthepu/todo-api.git

git clone https://github.com/pelthepu/todo-ui.git

```

Buld the files

```
cd todo-api

mvn clean package -DskipTests

nohup java -jar target/todo-1.0.0.jar > ~/todo-api/api.log 2>&1 &
echo $! > ~/todo-api/api.pid

```

Run the frontend

```
cd todo-ui

nano .env

REACT_APP_BACKEND_SERVER_URL=http://{ip of the machine}:8080

npm install

npm start

```

uninstalling everything

```

# Stop the API (if running in background)
kill $(cat ~/todo-app/api.pid) 2>/dev/null

# Stop Node/React (if running in foreground, just Ctrl+C, or:)
pkill -f "react-scripts"
pkill -f "node"
pkill -f "java"

rm -rf ~/todo-app

mongosh -u root -p password --authenticationDatabase admin

use todo
db.todos.drop()
exit

```

Stop and remove MongoDB completely

```

sudo systemctl stop mongod
sudo systemctl disable mongod
sudo apt-get purge -y mongodb-org*
sudo rm -rf /var/lib/mongodb
sudo rm -rf /var/log/mongodb
sudo rm -f /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo rm -f /usr/share/keyrings/mongodb-server-7.0.gpg
sudo apt-get autoremove -y

```

Remove Java 11

```
sudo apt-get purge -y openjdk-11-jdk openjdk-11-jre
sudo apt-get autoremove -y

```

Remove Maven

```
sudo apt-get purge -y maven
sudo apt-get autoremove -y

```

Remove Node.js

```
sudo apt-get purge -y nodejs
sudo rm -f /etc/apt/sources.list.d/nodesource.list
sudo apt-get autoremove -y

```

Clean apt cache

```
sudo apt-get clean
sudo apt-get update

```

Verify everything is gone

```
java -version      # should say "not found"
mvn -version       # should say "not found"
node -v            # should say "not found"
mongosh            # should say "not found"


```
