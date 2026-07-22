# ROI — The Legal App (Rules of India)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://react.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Groq](https://img.shields.io/badge/Groq-AI-orange?style=for-the-badge&logo=openai&logoColor=white)](https://groq.com)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)

An enterprise-grade, multi-platform legal assistance ecosystem built with **Flutter (Mobile)** and **React (Web)**, designed to democratize legal awareness and empower Indian citizens with constitutional and legal knowledge via advanced Artificial Intelligence.

---

## Table of Contents
- [System Architecture

`mermaid
graph TD
    A[Citizen User] --> B[Flutter Mobile App]
    A --> C[React Web App]

    subgraph Client Layer
        B
        C
    end

    subgraph Orchestration & Data Layer
        D[(Firebase Auth)]
        E[(Firestore DB)]
        F[(Firebase Storage)]
    end

    subgraph AI Processing Core
        G[Google Gemini Pro]
        H[Groq Llama 3]
        I[OpenAI GPT-4]
    end

    B -->|Auth & Analytics| D
    B -->|User Data & Sync| E
    C -->|Configuration| E

    B -->|Secure API Requests| G
    B -->|Voice AI Inference| H
    C -->|Deep Legal Parsing| I
`

## Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Directory Structure

`	ext
ROI-THE-LEGAL-APP/
├── roi_app/                  # Flutter Mobile Application
│   ├── lib/
│   │   ├── consts.dart       # API & Theme configurations
│   │   ├── screens/          # NEEDHi Chat, Quiz, and Legal Info Screens
│   │   └── main.dart         # Entrypoint
│   └── android/app/          # Android Native wrapper
├── legalytics-react/         # React Web Companion Dashboard
│   ├── src/
│   │   ├── components/       # Custom Legal UI Elements
│   │   └── services/         # API & Groq connection modules
│   └── App.js                # Web UI Orchestration
└── README.md                 # Project Documentation
`

---

## 