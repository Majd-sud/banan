import sqlite3
from pathlib import Path
import random
from datetime import datetime, timedelta
from typing import Optional, Dict, Any

# Base paths
BASE_DIR = Path(__file__).resolve().parent.parent  # backend/
DB_DIR = BASE_DIR / "databases"

ABSER_DB_PATH = DB_DIR / "absher_users.db"
DIGITAL_FP_DB_PATH = DB_DIR / "digital_fingerprints.db"


def ensure_db_folder_exists() -> None:
    """Ensure databases/ folder exists."""
    DB_DIR.mkdir(parents=True, exist_ok=True)


def get_connection(db_path: Path) -> sqlite3.Connection:
    """Return a connection to the given SQLite DB."""
    ensure_db_folder_exists()
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    return conn


# ---------- DIGITAL FINGERPRINT DB SETUP ----------

def init_digital_fingerprints_db() -> None:
    """Create tables for digital fingerprint storage if they don't exist."""
    conn = get_connection(DIGITAL_FP_DB_PATH)
    cur = conn.cursor()

    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS fingerprints (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_number TEXT NOT NULL,
            digital_fingerprint TEXT NOT NULL,
            issue_date TEXT NOT NULL,
            expiry_date TEXT NOT NULL
        )
        """
    )

    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS operations_log (
            log_id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_number TEXT,
            operation_description TEXT NOT NULL,
            timestamp TEXT NOT NULL
        )
        """
    )

    conn.commit()
    conn.close()


# ---------- HELPER: LOGGING ----------

def log_operation(id_number: Optional[str], description: str) -> None:
    """Insert an operation into operations_log."""
    conn = get_connection(DIGITAL_FP_DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO operations_log (id_number, operation_description, timestamp)
        VALUES (?, ?, ?)
        """,
        (id_number, description, datetime.utcnow().isoformat())
    )
    conn.commit()
    conn.close()


# ---------- HELPER: DIGITAL FINGERPRINT GENERATION ----------

def generate_digital_fingerprint() -> str:
    """
    Generate a 7-digit digital fingerprint code.
    This is a secure digital identifier, NOT a biometric image.
    """
    return str(random.randint(1_000_000, 9_999_999))


def save_digital_fingerprint(id_number: str, code: str) -> None:
    """Save a new digital fingerprint record for a user."""
    conn = get_connection(DIGITAL_FP_DB_PATH)
    cur = conn.cursor()

    issue_date = datetime.utcnow()
    expiry_date = issue_date + timedelta(days=365 * 5)  # 5 years, example

    cur.execute(
        """
        INSERT INTO fingerprints (id_number, digital_fingerprint, issue_date, expiry_date)
        VALUES (?, ?, ?, ?)
        """,
        (
            id_number,
            code,
            issue_date.date().isoformat(),
            expiry_date.date().isoformat(),
        ),
    )

    conn.commit()
    conn.close()

    log_operation(
        id_number,
        f"Issued new digital fingerprint code {code}"
    )


# ---------- ABSHER USERS DB ACCESS ----------

def get_absher_user(id_number: str) -> Optional[Dict[str, Any]]:
    """
    Retrieve a user row from absher_users.db.

    Expected schema for table users:
      - id_number TEXT PRIMARY KEY
      - first_name TEXT
      - last_name TEXT
      - gender TEXT
      - age INTEGER
      - has_real_fingerprint INTEGER (0 or 1)
      - service_suspension INTEGER (0 or 1)
    """
    if not ABSER_DB_PATH.exists():
        # DB not found – in real deployment we would raise/log
        return None

    conn = get_connection(ABSER_DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT * FROM absher_users WHERE id_number = ?", (id_number,))

    row = cur.fetchone()
    conn.close()

    if row is None:
        return None

    return dict(row)
# Ensure the digital_fingerprints.db and its tables exist
init_digital_fingerprints_db()

