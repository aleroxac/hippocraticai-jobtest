import sys
from flask import Flask, jsonify
from os import environ

api_host = environ.get("API_HOST")
api_port = environ.get("API_PORT")
visitor_name = environ.get("VISITOR_NAME")

app = Flask(__name__)

@app.route("/hello")
def hello():
    return jsonify({"message": f"Hello {visitor_name}!"})

@app.route("/health")
def health():
    return jsonify({"status": "UP"})

if __name__ == "__main__":
    for env in ["API_HOST", "API_PORT", "VISITOR_NAME"]:
        if env not in environ:
            print(f"[MISSING_VAR] - Please, provide the environment variable: {env}")
            sys.exit(1)

    app.run(host=api_host, port=int(api_port), debug=True)
