# ROI - THE LEGAL APP (Rules of India)

A comprehensive legal assistance platform built with Flutter and React, designed to empower Indian citizens with legal knowledge using AI.

## ⚠️ Important Security Notice
**Only Sriram (the owner) can access all APIs and related services.** 
All API keys have been removed from the public source code for security. To use the AI features (Gemini, ChatGPT, Groq), you must provide your own API keys in the respective configuration files.

**DO NOT try to pirate or misuse this application.** Contact the owner for authorized access or collaboration.

---

## 📱 Features
- **NEEDHi (AI Legal Tutor)**: A structured AI chatbot that explains Indian Constitutional laws in multiple local languages (Hindi, Tamil, Telugu, etc.).
- **VIDDHI (Voice AI)**: A hands-free voice assistant for conversational legal advice.
- **AI Daily Quiz**: Dynamically generated legal challenges to test your knowledge of the Constitution.
- **IPC vs BNS**: Detailed comparisons and information on Indian Penal Code and the new Bharatiya Nyaya Sanhita.
- **Fundamental Rights**: Easy-to-understand explanations of your rights.

## 🚀 Tech Stack
- **Mobile**: Flutter (Dart)
- **Web**: React.js
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **AI Integration**: Groq (Llama 3), Google Gemini, OpenAI
- **UI/UX**: Custom themed components with Inter and Plus Jakarta Sans typography.

## 🛠️ Getting Started (For Future Use)
1. **Clone the repository**:
   ```bash
   git clone https://github.com/SriramGandhiS/ROI-THE-LEGAL-APP.git
   ```
2. **Setup Flutter**:
   - Navigate to `roi_app/`.
   - Run `flutter pub get`.
   - Add your `google-services.json` to `android/app/`.
   - Add your API keys in `lib/consts.dart` and `lib/screens/ChatbotScreen.dart`.
3. **Setup React**:
   - Navigate to `legalytics-react/`.
   - Run `npm install`.
   - Add your Groq API key in `src/services/groq.js`.

## 📄 License
This project is for educational and portfolio purposes. All rights reserved by Sriram Gandhi S.
