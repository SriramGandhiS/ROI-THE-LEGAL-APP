# ROI — The Legal App (Rules of India)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://react.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Groq](https://img.shields.io/badge/Groq-AI-orange?style=for-the-badge&logo=openai&logoColor=white)](https://groq.com)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)

An enterprise-grade, multi-platform legal assistance ecosystem built with **Flutter (Mobile)** and **React (Web)**, designed to democratize legal awareness and empower Indian citizens with constitutional and legal knowledge via advanced Artificial Intelligence.

---

## Table of Contents
- [System Architecture](#system-architecture)
- [Key Features](#key-features)
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

## System Architecture

\\mermaid
graph TD
    A[Citizen User] -->|Flutter Mobile App| B(Mobile Front-End)
    A -->|React Web App| C(Web Admin/Chat Console)
    
    subgraph Client Layer
        B
        C
    end

    subgraph Orchestration & Data Layer
        D[Firebase Auth]
        E[Firestore DB]
        F[Firebase Storage]
    end

    subgraph AI Processing Core
        G[Google Gemini Pro]
        H[Groq Llama 3]
        I[OpenAI GPT-4]
    end

    B -->|Auth & Analytics| D
    B -->|User Data & Offline Sync| E
    C -->|Configuration & Auditing| E
    
    B -->|Secure API Requests| G
    B -->|Voice AI Inference| H
    C -->|Deep Legal Document Parsing| I
\
---

## Key Features

### 1. NEEDHi (AI Legal Tutor)
*   A sophisticated, structured AI chatbot designed to explain complex Indian Constitutional laws, criminal codes, and civic rights.
*   **Multilingual Support**: Fully localized legal advice dynamically translated and rendered in multiple languages (Hindi, Tamil, Telugu, Kannada, Bengali, etc.).

### 2. VIDDHI (Voice AI Assistant)
*   A hands-free, high-speed voice assistant that integrates browser/device microphones with real-time speech-to-text and AI legal logic to provide instant verbal legal consultations.

### 3. AI-Driven Daily Quiz
*   An interactive feature that dynamically generates daily legal scenario challenges to test the user's understanding of fundamental rights and constitutional provisions, tracking scores inside Firebase.

### 4. Statute Transformation (IPC vs. BNS)
*   A comprehensive comparative tool mapping sections of the legacy **Indian Penal Code (IPC)** directly to the newly enacted **Bharatiya Nyaya Sanhita (BNS)** to assist users and legal professionals in understanding transitional codes.

---

## Tech Stack

*   **Mobile Framework**: Flutter (Dart) with Bloc/Provider state management
*   **Web Console**: React.js with Tailwind CSS
*   **Backend & DB**: Firebase (Authentication, Firestore Realtime Database, Cloud Storage)
*   **AI Models**: Groq Llama 3, Google Gemini Pro, OpenAI GPT-4 API
*   **Design System**: Curated Plus Jakarta Sans & Inter typography, sleek dark mode aesthetics

---

## 