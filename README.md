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
- [Project Directory Structure](#project-directory-structure)
- [Security & Access Configuration](#security--access-configuration)
- [Installation & Setup](#installation--setup)
- [License & Intellectual Property](#license--intellectual-property)
- [Contributors](#contributors)

---



## Interactive Feature & Workflow Showcase

| Module | Core Functionality | Live Status & Flow |
| :--- | :--- | :--- |
| **NEEDHi AI Legal Tutor** | Interactive real-time legal assistant for IPC & BNS sections | Active → User Query → Groq/Gemini Llama Inference → Instant Advice |
| **Gamified Scenarios** | Legal scenario challenges with points & ranking system | Active → Situation Simulation → Decision Logic → Score Calculation |
| **Legalytics Web Console** | Administrative dashboard for tracking user cases & queries | Active → React Dashboard → Firebase Realtime Sync → Audit Logs |
| **Multilingual Voice AI** | Voice-to-text legal query processing in local languages | Active → Speech Input → Whispers Model → Text Translation → Answer |


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

## Project Directory Structure

\\	ext
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
│   │   ├── services/         # API & Groq connection modules
│   │   └── App.js            # Web UI Orchestration
└── README.md                 # Project Documentation
\
---

## Security & Access Configuration

> [!IMPORTANT]
> **API Key Sanitization Notice:** All production API keys (Gemini, OpenAI, Groq, and Firebase credentials) have been removed from the public repository to prevent security risks. 
> To test the interactive AI features, you must configure your local configuration files with valid API tokens as detailed in the setup steps.

---

## Installation & Setup

### Running the Flutter Mobile App
1. Navigate to the mobile application directory:
   \\ash
   cd roi_app
   \2. Fetch project dependencies:
   \\ash
   flutter pub get
   \3. Add your \google-services.json\ (downloaded from your Firebase Console) to the \ndroid/app/\ directory.
4. Input your custom API keys into the corresponding config file:
   * Edit \lib/consts.dart\ or \lib/screens/ChatbotScreen.dart5. Launch the application on a connected device/emulator:
   \\ash
   flutter run
   \
### Running the React Web Dashboard
1. Navigate to the web project directory:
   \\ash
   cd legalytics-react
   \2. Install npm packages:
   \\ash
   npm install
   \3. Create a \.env\ file in the root of the folder and configure your API endpoint:
   \\env
   REACT_APP_GROQ_API_KEY=your_groq_key_here
   \4. Start the development server:
   \\ash
   npm start
   \
---

## License & Intellectual Property

**Proprietary Portfolio Project** — All rights reserved by **Sriram S**.

This repository is published exclusively for educational review, architectural assessment, and portfolio evaluation. Unauthorized replication, redistribution, commercialization, or modifications of this source code are strictly prohibited without consent from EAT AND LEARN TEAM.

*Developed by [Sriram S](https://github.com/SriramGandhiS).*

---

## Contributors

- **Sanjay Kumar** ([@sanjaysekar5](https://github.com/sanjaysekar5)) - Backend Engineer | Java & Spring Boot


---

---

---

---

---

---

---

## Hackathon Winner & Core Development Team

Developed by **EAT AND LEARN TEAM**

| Avatar | Contributor Name | GitHub Handle | Role & Specialization | GitHub Profile / Fork |
| :---: | :--- | :--- | :--- | :--- |
| <img src="https://github.com/SriramGandhiS.png" width="50"> | **Sriram S** | `@SriramGandhiS` | API Integration, Overall Development & Team Management | [Profile](https://github.com/SriramGandhiS) |
| <img src="https://github.com/Solairajan1509.png" width="50"> | **Solairajan** | `@Solairajan1509` | Full Stack Developer | [Fork Repo](https://github.com/Solairajan1509/ROI-THE-LEGAL-APP) |
| <img src="https://ui-avatars.com/api/?name=Vengata+Visva&background=0D8ABC&color=fff" width="50"> | **Vengata Visva** | `Vengata Visva` | Lead Mobile Engineer & Flutter Architecture | Team Member |
| <img src="https://github.com/Suriyakumar4036.png" width="50"> | **Suriya Kumar** | `@Suriyakumar4036` | R & D (Research & Development) | [Fork Repo](https://github.com/Suriyakumar4036/ROI-THE-LEGAL-APP) |
| <img src="https://github.com/sanjaysekar5.png" width="50"> | **Sanjay Sekar** | `@sanjaysekar5` | Git Actions | [Fork Repo](https://github.com/sanjaysekar5/ROI-THE-LEGAL-APP) |
| <img src="https://github.com/selvinjef123.png" width="50"> | **Selvin Jef** | `@selvinjef123` | Tester | [Fork Repo](https://github.com/selvinjef123/ROI-THE-LEGAL-AP) |
| <img src="https://github.com/redeyeshu007.png" width="50"> | **Red Eye Shu** | `@redeyeshu007` | Lead Solution Architect & Feature Specialist | [Fork Repo](https://github.com/redeyeshu007/ROI-THE-LEGAL-APP) |
| <img src="https://github.com/rizz-architect.png" width="50"> | **Rizz Architect** | `@rizz-architect` | CI/CD Pipeline & Automated Workflows | [Fork Repo](https://github.com/rizz-architect/ROI-THE-LEGAL-APP) |

---

Developed by **EAT AND LEARN TEAM**
