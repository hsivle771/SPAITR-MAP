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