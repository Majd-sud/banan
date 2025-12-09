from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from banan_ai.banan_ai import handle_digital_fingerprint_request  # الموديل محمل تلقائيًا

app = FastAPI()

# تمكين طلبات من Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Input model from Flutter
class NationalIDRequest(BaseModel):
    national_id: str


@app.post("/api/verify_national_id")
def verify_national_id(req: NationalIDRequest):
    national_id = req.national_id.strip()
    print(f"═════════════════════════════════════════════════════════════════════")
    print(f"🟢 [DEBUG] Received National ID: {national_id}")

    # Validate National ID format
    if not national_id.isdigit() or len(national_id) != 10:
        print("❌ [DEBUG] Invalid national ID format")
        raise HTTPException(status_code=400, detail="Invalid national ID format")

    print("🔄 [DEBUG] Calling AI engine...")
    try:
        result = handle_digital_fingerprint_request(national_id)
    except Exception as e:
        print(f"🚨 [DEBUG] Error during AI processing: {e}")
        raise HTTPException(status_code=500, detail=f"AI processing error: {e}")

    print(f"✅ [DEBUG] AI result: {result}")

    if result.get("status") == "not_found":
        return {"status": "not_found"}

    return {
        "status": "found",
        "first_name": result["user"].get("first_name"),
        "last_name": result["user"].get("last_name"),
        "id_number": result["user"].get("id_number"),
        "age": result["user"].get("age"),
        "has_real_fingerprint": result["user"].get("has_real_fingerprint"),
        "service_suspension": result["user"].get("service_suspension"),
        "decision": result.get("decision"),
        "digital_fingerprint": result.get("digital_fingerprint"),
        "probability_allow": result.get("probability_allow"),
        "message": result.get("message"),
    }


@app.get("/")
def root():
    return {"message": "BANAN AI Backend is running"}






# """
# BANAN Backend – Main CLI Entry Point

# This file:
# - Asks the user for a national ID
# - Calls the AI engine (banan_ai.handle_digital_fingerprint_request)
# - Prints decision results in a clean format
# - Logs every request in digital_fingerprints.db
# """

# from pathlib import Path
# import sys

# # Import AI prediction engine
# from banan_ai.banan_ai import handle_digital_fingerprint_request


# def pretty_print_result(res: dict):
#     print("\n" + "=" * 60)
#     print("🟦 BANAN – Digital Fingerprint Issuance Result")
#     print("=" * 60)

#     if res["status"] == "not_found":
#         print("❌ User not found in Absher database.")
#         return

#     user = res.get("user", {})

#     print(f"👤 User    : {user.get('first_name')} {user.get('last_name')}")
#     print(f"🆔 ID      : {user.get('id_number')}")
#     print(f"🎂 Age     : {user.get('age')}")
#     print(f"🖐 Real FP : {user.get('has_real_fingerprint')}")
#     print(f"⛔ Suspension: {user.get('service_suspension')}")
#     print("-" * 60)

#     decision = res.get("decision")
#     prob = res.get("probability_allow", 0)

#     if decision == "allow":
#         print(f"✅ AI Decision: ALLOW (confidence: {prob:.2f})")
#         print(f"🟢 Digital Fingerprint Issued: {res.get('digital_fingerprint')}")
#     else:
#         print(f"❌ AI Decision: DENY (confidence: {prob:.2f})")

#     print("\nℹ️ Message:")
#     print(res.get("message", ""))
#     print("=" * 60)


# def main():
#     print("===============================================")
#     print("        🟦 BANAN – Digital Fingerprint AI       ")
#     print("===============================================\n")

#     # Ask user for national ID
#     id_number = input("🔎 Enter National ID Number: ").strip()

#     if not id_number.isdigit() or len(id_number) != 10:
#         print("❌ Invalid ID format. Expected a 10-digit national ID.")
#         sys.exit(1)

#     # Call AI engine
#     result = handle_digital_fingerprint_request(id_number)

#     # Print result nicely
#     pretty_print_result(result)


# if __name__ == "__main__":
#     main()
