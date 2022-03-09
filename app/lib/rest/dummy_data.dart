// TODO: This is only temporary until server is set up and returns real information
const DUMMY_FETCHGAMES_JSON = '''
    [ 
        {
            "gameId": "1", 
            "coorX": "43.1473344217516", 
            "coorY": "-70.96334267332212",
            "startTime": "4:15 PM",
            "creatorId": "1",
            "players": ["2"]
        },
        {
            "gameId": "2", 
            "coorX": "43.1477991", 
            "coorY": "-70.963315",
            "startTime": "4:16 PM",
            "creatorId": "2",
            "players": ["1"]
        }
    ]
    ''';

const DUMMY_CREATEGAME_JSON = '''
    {
        "success": "true", 
        "error_msg": ""
    }
    ''';