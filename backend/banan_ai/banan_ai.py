"""
BANAN AI Runtime Engine

- Loads trained Decision Tree model (banan_ai_model.joblib)
- Takes national ID as input
- Fetches user from absher_users.db
- Builds feature vector [has_real_fingerprint, service_suspension]
- Predicts whether user is allowed to get a digital fingerprint
- If allowed, generates and stores a 7-digit digital fingerprint code
"""

from pathlib import Path
from typing import Dict, Any

import joblib
import numpy as np

from utils import helpers

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "banan_ai_model.joblib"


# Load model once at import
if not MODEL_PATH.exists():
    raise FileNotFoundError(
        f"AI model not found at {MODEL_PATH}. "
        "Please run train_model.py first to generate banan_ai_model.joblib."
    )

MODEL = joblib.load(MODEL_PATH)


def _build_features_from_user(user: Dict[str, Any]) -> np.ndarray:
    """
    Convert Absher user row to numeric feature vector for the model.

    Expected keys:
      - has_real_fingerprint (0/1 or bool)
      - service_suspension (0/1 or bool)

    Returns:
      2D array of shape (1, 2) for sklearn: [[has_real_fingerprint, service_suspension]]
    """
    has_real_fp = int(user.get("has_real_fingerprint", 0))
    service_suspension = int(user.get("service_suspension", 0))

    features = np.array([[has_real_fp, service_suspension]], dtype=float)
    return features


def handle_digital_fingerprint_request(id_number: str) -> Dict[str, Any]:
    """
    Main AI workflow for a digital fingerprint issuance request.

    Returns a dictionary with:
      - status: "ok" | "not_found" | "error"
      - message: human-readable explanation
      - decision: "allow" | "deny" (if status == "ok")
      - probability_allow: float (0–1)
      - user: user summary (if found)
      - digital_fingerprint: code (if allowed and issued)
    """
    # Fetch user from Absher DB
    user = helpers.get_absher_user(id_number)

    if user is None:
        helpers.log_operation(id_number, "User not found in Absher DB")
        return {
            "status": "not_found",
            "message": "User not found in Absher database.",
        }

    # Build feature vector (must match training features order)
    X = _build_features_from_user(user)

    # Predict probability (classes should be [0 -> deny, 1 -> allow])
    proba = MODEL.predict_proba(X)[0]
    # Assuming training labels: 0 = deny, 1 = allow
    p_deny, p_allow = float(proba[0]), float(proba[1])

    decision_label = "allow" if p_allow >= 0.5 else "deny"

    result: Dict[str, Any] = {
        "status": "ok",
        "message": "",
        "decision": decision_label,
        "probability_allow": p_allow,
        "user": {
            "id_number": user.get("id_number"),
            "first_name": user.get("first_name"),
            "last_name": user.get("last_name"),
            # age is still useful for display, but NOT used in the model
            "age": user.get("age"),
            "has_real_fingerprint": user.get("has_real_fingerprint"),
            "service_suspension": user.get("service_suspension"),
        },
    }

    if decision_label == "deny":
        msg = (
            "Request denied by AI model based on current rules "
            "(e.g., no real fingerprint in Absher, or active service suspension)."
        )
        result["message"] = msg
        helpers.log_operation(
            id_number,
            "Denied digital fingerprint request based on AI model",
        )
        return result

    # If allowed → generate and store code
    code = helpers.generate_digital_fingerprint()
    helpers.save_digital_fingerprint(id_number, code)

    result["digital_fingerprint"] = code
    result["message"] = "Digital fingerprint successfully generated."
    helpers.log_operation(
        id_number,
        f"Issued digital fingerprint code {code}",
    )

    return result
