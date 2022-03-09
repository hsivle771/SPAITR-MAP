from pymongo import MongoClient

class Connect(object):
    @staticmethod    
    def get_connection():
        return MongoClient("mongodb+srv://spaitrAdmin:spaitr@testcluster.dy8i5.mongodb.net/myFirstDatabase?retryWrites=true&w=majority")