from flask import Flask, request, jsonify
from threading import Thread
from queue import Queue
from sagemath_agents import sagemath_act
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

def run_linalg_request_async(output_queue, user_message):
    response = sagemath_act(user_message)
    output_queue.put(response)

@app.route("/api/endpoint", methods=["POST"])
def api_endpoint():
    data = request.get_json()
    if 'user_message' not in data:
        return jsonify({"error": "Missing 'user_message' in request"}), 400

    user_message = data['user_message']
    output_queue = Queue()
    thread = Thread(target=run_linalg_request_async, args=(output_queue, user_message))
    thread.start()
    thread.join()
    response = output_queue.get()
    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=False, use_reloader=False, port=5010)