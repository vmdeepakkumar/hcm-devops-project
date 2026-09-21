from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "application": "Healthcare Management System",
        "status": "Running",
        "environment": "Development"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "UP"
    })


@app.route("/appointments")
def appointments():
    return jsonify({
        "module": "Appointments",
        "status": "Available"
    })


@app.route("/opd")
def opd():
    return jsonify({
        "module": "OPD",
        "status": "Available"
    })


@app.route("/ipd")
def ipd():
    return jsonify({
        "module": "IPD",
        "status": "Available"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)