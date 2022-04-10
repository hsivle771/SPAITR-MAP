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
        # return MongoClient("mongodb://root:123456@mongodb/test_db?retryWrites=true&w=majority&authSource=admin")
        
        return MongoClient("mongodb+srv://spaitrAdmin:spaitr@testcluster.dy8i5.mongodb.net/myFirstDatabase?retryWrites=true&w=majority")