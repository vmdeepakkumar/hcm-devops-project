from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)


def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "hmsci_db")
    )


@app.route("/")
def home():
    return jsonify({
        "application": "Healthcare Management System",
        "status": "Running",
        "environment": "Development"
    })


@app.route("/health")
@app.route("/live")
def liveness():
    return jsonify({
        "status": "UP",
        "check": "liveness"
    }), 200


@app.route("/ready")
def readiness():
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("SELECT 1")
        cursor.fetchone()

        return jsonify({
            "status": "READY",
            "checks": {
                "database": "UP"
            }
        }), 200

    except mysql.connector.Error:
        return jsonify({
            "status": "NOT_READY",
            "checks": {
                "database": "DOWN"
            }
        }), 503

    finally:
        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()


@app.route("/appointments")
def appointments():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT id, patient_name, doctor_name,
                   appointment_date, status
            FROM appointments
        """)

        appointments_data = cursor.fetchall()

        cursor.close()
        connection.close()

        return jsonify({
            "module": "Appointments",
            "status": "Available",
            "data": appointments_data
        })

    except mysql.connector.Error as error:
        return jsonify({
            "module": "Appointments",
            "status": "Database connection failed",
            "error": str(error)
        }), 500


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