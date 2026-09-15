from flask import Flask,jsonify

app = Flask(__name__)

@app.route("/")
def root():
    return jsonify({"message":"hello world"})



if __name__ == "__main__":
    app.run(host="127.0.0.1",port=5173,debug=True)
