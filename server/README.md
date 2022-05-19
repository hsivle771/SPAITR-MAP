# SPAITR-MAP Server

The SPAITR Map Server is run using Flask with Python and MongoDB.

## How to run the SPAITR Map Server

## Option 1: With Docker
The server has been configured with Docker to easily grab all of the needed dependencies and spin up a local instance of the MongoDB to be used as the database.

#### Prerequisites:
* Install Docker. Installation info: https://docs.docker.com/get-docker/
* Install docker-compose. Installation info: https://docs.docker.com/compose/install/

#### Instructions:
1. Inside of a terminal, navigate to the directory `spaitr-map/server/`. From here, you should see a file called `docker-compose.yml`.

2. Run the following command to start docker-compose and get an instance of the server and database running:
```
$ docker-compose up --build
```
This will probably take a few minutes for Docker to get everything installed. Subsequent runs should be faster. 

3. The server should be live at the address: http://127.0.0.1:5000/ and ready to run!

**Note**: By default, the server attempts to connect to the local database spun up by Docker. If you have a live production database you would like to use,
you need to edit the line contents of `return MongoClient("...")` in the `spaitr-map/server/connect.py` file:
```
from pymongo import MongoClient

class Connect(object):
    @staticmethod    
    def get_connection():
        # Running with Docker
        # To view it in MongoDB Compass:
        #  - Host: localhost
        #  - Port: 7017
        #  - Username: root
        #  - Password: 123456
        return MongoClient("mongodb://root:123456@mongodb/test_db?retryWrites=true&w=majority&authSource=admin")
        
	# Running with live database:
        # return MongoClient("<INSERT DATABASE URL HERE>")
```

## Option 2: Without Docker

It is also possible to run the server without Docker.

#### Prerequisites:
* Install Python. Installation info: https://www.python.org/downloads/
* Install Pipenv. Installation info: https://pypi.org/project/pipenv/
* Setup a MongoDB instance. Setup info: https://www.mongodb.com/basics/create-database

#### Instructions: 
1. Inside of a terminal, navigate to the directory `spaitr-map/server/`. From here, you should see a file called `Pipfile`.

2. Run the following command to install the needed Python dependencies with pipenv inside of a virtual environment:
```
$ pipenv install
```

3. Enter the created pipenv virtual environment:
```
$ pipenv shell
```

4. Set the following environment variable:
```
$ export FLASK_APP=basicRestMethods
```

5. Start the flask server:
```
$ flask run
```

6. The server should be live on http://127.0.0.1:5000/ and ready to run!

**Note**: By default, the server is set up to be pointed to the locally run MongoDB database that Docker would generate. Since this option does not use Docker, a different method will need to be
used to get a MongoDB database running. For information on how to set up a MongoDB database, check out: https://www.mongodb.com/basics/create-database.
If you decide to go with this approach, you'll need to modify the contents of `return MongoClient(...)` in the `spaitr-map/server/connect.py` file as mentioned in the Option 1 section. 