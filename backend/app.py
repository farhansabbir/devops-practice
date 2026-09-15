import os

from bson.json_util import dumps
from flask import Flask, Response, request
from pymongo import MongoClient
import datetime

app = Flask(__name__)

mongo_uri = os.environ.get("MONGO_URI", "mongodb://localhost:27017")
mongo_db = os.environ.get("MONGO_DB", "app")
client = MongoClient(mongo_uri)
db = client[mongo_db]

@app.route("/api", methods=["GET"])
def root():
    data = dict()
    data["dt"] = datetime.datetime.now()
    data["method"] = request.method
    data["path"] = request.path
    data["remote_addr"] = request.remote_addr
    data["args"] = request.args.to_dict()
    db.data.insert_one(data)

    items = list(db.data.find())
    return Response(dumps(items), mimetype="application/json")



if __name__ == "__main__":
    app.run(host="0.0.0.0",port=5173,debug=True)
