# BANAN — AI-Powered Digital Fingerprint System

BANAN is an AI-powered digital fingerprint issuance system developed for the **Absher Tawiyq Challenge – Absher Hackathon 2025**.

The system uses Machine Learning to evaluate a user's eligibility for obtaining a digital fingerprint based on their Absher records. It automates the eligibility decision and generates a unique 7-digit digital fingerprint code for eligible users.

## Project Overview

BANAN aims to simplify digital fingerprint issuance through an intelligent eligibility verification process.

Instead of relying on manual verification, the system retrieves user information from an Absher database, processes relevant eligibility indicators, and uses a trained Decision Tree model to determine whether a digital fingerprint can be issued.

## Key Features

- **AI-Based Eligibility Prediction:** Uses a trained Decision Tree classifier to evaluate digital fingerprint requests.
- **Absher Database Integration:** Retrieves user records using their national ID.
- **Automated Verification:** Evaluates fingerprint availability and service suspension status.
- **Digital Fingerprint Generation:** Generates a unique 7-digit code for eligible users.
- **Operation Logging:** Records issuance requests, eligibility decisions, and unsuccessful lookups.
- **Probability-Based Decisions:** Calculates the model's predicted probability of approval.

## How It Works

The BANAN AI Runtime Engine follows these steps:

1. **Load AI Model:** Loads the pre-trained Decision Tree model (`banan_ai_model.joblib`).
2. **Receive National ID:** Accepts the user's national ID as input.
3. **Retrieve User Data:** Fetches the corresponding user record from `absher_users.db`.
4. **Build Feature Vector:** Extracts two eligibility indicators:
   - `has_real_fingerprint`
   - `service_suspension`
5. **Predict Eligibility:** Passes the feature vector to the trained model to predict approval or rejection.
6. **Generate Digital Fingerprint:** If approved, generates and stores a 7-digit digital fingerprint code.
7. **Log Operation:** Records the result of the request.

## AI Model

BANAN uses a **Decision Tree Classifier** to predict whether a user is eligible to receive a digital fingerprint.

### Model Input Features

| Feature | Description |
|---|---|
| `has_real_fingerprint` | Indicates whether the user has an existing real fingerprint registered in Absher. |
| `service_suspension` | Indicates whether the user's services are suspended. |

The model receives the following feature vector:

```python
[
    has_real_fingerprint,
    service_suspension
]
```

### Prediction Output

The model uses two classification labels:

- `0` — Deny
- `1` — Allow

The system evaluates the approval probability using `predict_proba()`.

A request is approved when:

```python
probability_allow >= 0.5
```

Otherwise, the request is denied.

**Note:** The model's feature order and classification labels must remain consistent with the training configuration.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Core runtime and application logic |
| Scikit-learn | Machine Learning and Decision Tree classification |
| NumPy | Feature vector construction |
| Joblib | Model serialization and loading |
| SQLite | Absher user database |
| Python Pathlib | File and model path management |

## Project Structure

```text
BANAN/
│
├── ai_engine.py
├── train_model.py
├── banan_ai_model.joblib
├── absher_users.db
│
└── utils/
    └── helpers.py
```

*The structure above represents the main components referenced by the runtime engine.*

## Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd BANAN
```

### 2. Install Dependencies

```bash
pip install numpy joblib scikit-learn
```

### 3. Prepare the AI Model

Run the training script to generate the serialized Decision Tree model:

```bash
python train_model.py
```

This generates:

```text
banan_ai_model.joblib
```

### 4. Prepare the Database

Ensure that `absher_users.db` is available and contains the required user records.

### 5. Run the Application

Import the runtime function into your application:

```python
from ai_engine import handle_digital_fingerprint_request

result = handle_digital_fingerprint_request("NATIONAL_ID")

print(result)
```

## Example Response

**Approved Request:**

```json
{
    "status": "ok",
    "decision": "allow",
    "probability_allow": 0.95,
    "message": "Digital fingerprint successfully generated.",
    "digital_fingerprint": "1234567"
}
```

**Rejected Request:**

```json
{
    "status": "ok",
    "decision": "deny",
    "probability_allow": 0.12,
    "message": "Request denied by AI model based on current rules."
}
```


## Error Handling

The runtime engine handles the following situations:

- **User Not Found:** Returns `not_found` when the national ID does not exist in the Absher database.
- **Missing AI Model:** Raises a `FileNotFoundError` if the trained model is unavailable.
- **Rejected Request:** Returns a denial decision without generating a digital fingerprint.
- **Successful Issuance:** Generates, stores, and logs the digital fingerprint code.

## Project Purpose

BANAN demonstrates how Machine Learning can support digital government services by automating eligibility verification and streamlining digital fingerprint issuance.

The project explores the integration of AI, database management, and automated decision-making to support a more efficient digital service experience.

---

**Developed for:** Absher Hackathon 2025 — Absher Tawiyq Challenge

**Achievement:** Second Place — 2nd out of 483 participating teams.

**Prize:** SAR 150,000

**Focus Areas:** Artificial Intelligence · Machine Learning · Digital Government · Automation
