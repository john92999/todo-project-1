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

nohup java -jar target/todo-1.0.0.jar > ~/todo-app/api.log 2>&1 &
echo $! > ~/todo-app/api.pid

```

Run the frontend

```
cd todo-ui

nano .env

REACT_APP_BACKEND_SERVER_URL=http://{ip of the machine}:8080

npm install

npm start

```
