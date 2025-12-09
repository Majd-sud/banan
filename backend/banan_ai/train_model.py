"""
BANAN AI – Decision Tree Training Script

Guidelines followed:
1) Initialize the decision tree
2) Load the dataset (banan_ai_training_data.csv)
3) Perform exploratory data analysis (EDA)
4) Create basic visualizations
5) Preprocess data for machine learning
6) Separate features/target + train/test split (80/20)
7) Specify parameters (max_depth, min_samples_split, etc.)
8) Train & evaluate model (accuracy, report, confusion matrix)
9) Visualize the decision tree and save the model (.joblib)

⚠ Dataset columns :
- has_real_fingerprint (0/1)
- service_suspension (0/1)
- allowed_to_generate_digital_fingerprint (0/1)  ← target
"""

import os
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
)

import joblib

# Paths
BASE_DIR = Path(__file__).resolve().parent  # banan_ai/
DATA_PATH = BASE_DIR / "banan_ai_training_data.csv"
MODEL_PATH = BASE_DIR / "banan_ai_model.joblib"


def main():
    print("🔍 [1] Initializing training pipeline...")

    # ---------------------------------------------------
    # 2) Load the dataset
    # ---------------------------------------------------
    if not DATA_PATH.exists():
        raise FileNotFoundError(
            f"Training data not found at: {DATA_PATH}\n"
            "Please create banan_ai_training_data.csv with columns:\n"
            "has_real_fingerprint,service_suspension,allowed_to_generate_digital_fingerprint"
        )

    print(f"📂 [2] Loading data from {DATA_PATH} ...")
    df = pd.read_csv(DATA_PATH)

    # Ensure correct columns (NO age)
    required_cols = [
        "has_real_fingerprint",
        "service_suspension",
        "allowed_to_generate_digital_fingerprint",
    ]
    for col in required_cols:
        if col not in df.columns:
            raise ValueError(f"Missing required column in CSV: {col}")

    # ---------------------------------------------------
    # 3) EDA – basic inspection
    # ---------------------------------------------------
    print("\n📊 [3] Dataset head:")
    print(df.head())

    print("\n📊 Summary statistics:")
    print(df.describe(include="all"))

    print("\n📊 Target distribution (allowed_to_generate_digital_fingerprint):")
    print(df["allowed_to_generate_digital_fingerprint"].value_counts())

    # ---------------------------------------------------
    # 4) Basic visualizations
    # ---------------------------------------------------
    print("\n📈 [4] Creating simple visualizations...")

    # Bar chart: has_real_fingerprint vs decision
    fig1, ax1 = plt.subplots()
    df.groupby("has_real_fingerprint")["allowed_to_generate_digital_fingerprint"].mean().plot(
        kind="bar",
        ax=ax1,
    )
    ax1.set_title("Avg Allow Rate by has_real_fingerprint")
    ax1.set_xlabel("has_real_fingerprint (0/1)")
    ax1.set_ylabel("Average allow_to_generate")
    plt.tight_layout()
    fig1.savefig(BASE_DIR / "viz_allow_vs_has_real_fingerprint.png")
    plt.close(fig1)

    # Bar chart: service_suspension vs decision
    fig2, ax2 = plt.subplots()
    df.groupby("service_suspension")["allowed_to_generate_digital_fingerprint"].mean().plot(
        kind="bar",
        ax=ax2,
    )
    ax2.set_title("Avg Allow Rate by service_suspension")
    ax2.set_xlabel("service_suspension (0/1)")
    ax2.set_ylabel("Average allow_to_generate")
    plt.tight_layout()
    fig2.savefig(BASE_DIR / "viz_allow_vs_service_suspension.png")
    plt.close(fig2)

    print("✅ Visualizations saved as PNG in banan_ai/")

    # ---------------------------------------------------
    # 5) Preprocess data
    # ---------------------------------------------------
    print("\n🧹 [5] Preprocessing data for ML...")

    # Ensure integer/bool columns are int (and handle any NaNs defensively)
    for col in ["has_real_fingerprint", "service_suspension", "allowed_to_generate_digital_fingerprint"]:
        if df[col].isna().any():
            # Just in case generator produced NaNs; we treat them as 0 (safe default)
            df[col] = df[col].fillna(0)
        df[col] = df[col].astype(int)

    # ---------------------------------------------------
    # 6) Separate features and target + train/test split
    # ---------------------------------------------------
    print("\n✂️ [6] Splitting train/test...")

    # ONLY these two features
    X = df[["has_real_fingerprint", "service_suspension"]]
    y = df["allowed_to_generate_digital_fingerprint"]

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.2,
        random_state=42,
        stratify=y,
    )

    print(f"Training size: {len(X_train)} rows")
    print(f"Test size    : {len(X_test)} rows")

    # ---------------------------------------------------
    # 7) Initialize Decision Tree model with parameters
    # ---------------------------------------------------
    print("\n🌳 [7] Initializing DecisionTreeClassifier...")

    model = DecisionTreeClassifier(
        max_depth=4,
        min_samples_split=20,
        min_samples_leaf=10,
        random_state=42,
    )

    # ---------------------------------------------------
    # 8) Train & evaluate
    # ---------------------------------------------------
    print("\n🚀 [8] Training model...")
    model.fit(X_train, y_train)

    # Training performance
    y_train_pred = model.predict(X_train)
    train_acc = accuracy_score(y_train, y_train_pred)

    # Test performance
    y_test_pred = model.predict(X_test)
    test_acc = accuracy_score(y_test, y_test_pred)

    print(f"\n📏 Train accuracy: {train_acc:.3f}")
    print(f"📏 Test accuracy : {test_acc:.3f}")

    print("\n📄 Classification report (test set):")
    print(classification_report(y_test, y_test_pred))

    cm = confusion_matrix(y_test, y_test_pred)
    print("🧩 Confusion matrix (test set):")
    print(cm)

    # Confusion matrix plot
    fig_cm, ax_cm = plt.subplots()
    im = ax_cm.imshow(cm, cmap="Blues")
    ax_cm.set_title("Confusion Matrix")
    ax_cm.set_xlabel("Predicted")
    ax_cm.set_ylabel("Actual")
    for i in range(cm.shape[0]):
        for j in range(cm.shape[1]):
            ax_cm.text(j, i, cm[i, j], ha="center", va="center", color="black")
    plt.colorbar(im, ax=ax_cm)
    plt.tight_layout()
    fig_cm.savefig(BASE_DIR / "viz_confusion_matrix.png")
    plt.close(fig_cm)

    print("✅ Confusion matrix saved as viz_confusion_matrix.png")

    # ---------------------------------------------------
    # 9) Visualize decision tree & save model
    # ---------------------------------------------------
    print("\n🌳 [9] Visualizing decision tree and saving model...")

    fig_tree, ax_tree = plt.subplots(figsize=(10, 5))
    plot_tree(
        model,
        feature_names=["has_real_fingerprint", "service_suspension"],
        class_names=["deny", "allow"],
        filled=True,
        rounded=True,
        fontsize=8,
        ax=ax_tree,
    )
    plt.tight_layout()
    fig_tree.savefig(BASE_DIR / "viz_decision_tree.png")
    plt.close(fig_tree)

    print("✅ Decision tree visualization saved as viz_decision_tree.png")

    # Save the model
    joblib.dump(model, MODEL_PATH)
    print(f"💾 Model saved to {MODEL_PATH}")


if __name__ == "__main__":
    main()
