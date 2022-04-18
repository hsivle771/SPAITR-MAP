import string
from flask import Flask, request, jsonify
import json
from bson.json_util import dumps
from pymongo import MongoClient
from connect import Connect

app = Flask(__name__)

connection = Connect.get_connection()
db = connection.spaitr

@app.route('/nearby_games/<float:CURR_COOR_X>/<float:CURR_COOR_Y>', methods=['GET'])
def nearby_games(CURR_COOR_X: float, CURR_COOR_Y: float):
    nearbyCursor = db.games.find(
        {"$and": [{"x_coord": {"$gt": (CURR_COOR_X - 1.0)}}, {"x_coord": {"$lt": (CURR_COOR_X + 1.0)}}, {"y_coord": {"$gt": (CURR_COOR_Y - 1.0)}}, {"y_coord": {"$lt": (CURR_COOR_Y + 1.0)}}]}
    )

    nearbyGamesList = list(nearbyCursor)
    jsonData = dumps(nearbyGamesList)

    return jsonData

@app.route('/join_game/<string:GAME_ID>/<string:PLAYER_ID>', methods=['POST'])
def join_game(GAME_ID: string, PLAYER_ID: string):
    db.games.find_one_and_update(
        {'_id': GAME_ID},
        {   
            '$inc':{'player_count':1},
            '$push':{'player_list':PLAYER_ID}
        }
    )

    return jsonify(True)

@app.route('/create_game/<float:GAME_COOR_X>/<float:GAME_COOR_Y>/<string:START_DAY>/<string:START_TIME>/<int:MAX_PLAYERS>', methods=['PUT'])
def create_game(GAME_COOR_X: float, GAME_COOR_Y: float, START_DAY: string, START_TIME: string, MAX_PLAYERS: int):
    db.games.insert_one(
        {
            "_id" : str(GAME_COOR_X) + str(GAME_COOR_Y) + START_DAY + START_TIME,
            "x_coord" : GAME_COOR_X,
            "y_coord" : GAME_COOR_Y,
            "date" : START_DAY,
            "time" : START_TIME,
            "max_players" : MAX_PLAYERS,
            "player_count" : 0,
            "player_list" : []
        }
    )

    return jsonify(True)

@app.route('/', methods=['GET'])
def testServer():
    return jsonify(message = "Server is online")