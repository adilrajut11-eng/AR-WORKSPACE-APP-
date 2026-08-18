# 🏥 AI Doctor App - Respiratory Diseases Diagnosis

An AI-powered Flutter mobile app for diagnosing respiratory diseases using OpenAI API.

## ✨ Features

✅ **AI-Powered Diagnosis** - Uses ChatGPT for respiratory disease diagnosis  
✅ **Symptom Checker** - Select from common respiratory symptoms  
✅ **Confidence Score** - AI provides confidence percentage  
✅ **Recommendations** - Get actionable health recommendations  
✅ **Medicine Suggestions** - AI recommends common medicines  
✅ **Diagnosis History** - Track all previous diagnoses  
✅ **Beautiful UI** - Modern Material Design 3  
✅ **Dark Mode** - Full dark mode support  

## 📦 Installation

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- OpenAI API Key

### Quick Start

```bash
# Clone repository
git clone https://github.com/adilrajut11-eng/AR-WORKSPACE-APP-.git
cd AR-WORKSPACE-APP-

# Install dependencies
flutter pub get

# Setup API Key
cp .env.example .env
# Edit .env and add your OpenAI API Key

# Run
flutter run
```

## 🔑 API Configuration

1. Get API Key from [OpenAI](https://platform.openai.com/api-keys)
2. Add to `.env`:
   ```
   OPENAI_API_KEY=sk-your-key-here
   ```

## 📱 Screens

### 1. Symptoms Screen
- Select from common respiratory symptoms
- Add multiple symptoms
- Clear selection

### 2. Diagnosis Screen
- AI analyzes symptoms
- Shows confidence percentage
- Provides detailed diagnosis
- Lists recommendations
- Shows suggested medicines
- Alerts if doctor needed

### 3. History Screen
- View all past diagnoses
- Filter by disease
- See confidence scores
- Track symptoms over time

## 🏗️ Project Structure

```
AR-WORKSPACE-APP-/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── symptom.dart
│   ├── providers/
│   │   └── doctor_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── symptoms_screen.dart
│   │   ├── diagnosis_screen.dart
│   │   └── history_screen.dart
│   └── services/
│       └── ai_service.dart
├── pubspec.yaml
└── .env.example
```

## 🚀 Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 💡 Usage

1. **Select Symptoms** - Choose symptoms from the list
2. **Get Diagnosis** - AI analyzes and provides diagnosis
3. **Review Results** - Check confidence, recommendations, medicines
4. **Check History** - View all past diagnoses

## ⚠️ Important

- **NOT a substitute for professional medical advice**
- Always consult with a doctor for serious conditions
- This is an educational tool
- Keep API key secure
- Monitor API usage and costs

## 📄 License

MIT License - Use freely

## 👨‍💻 Author

**Adil Rajut**
- GitHub: [@adilrajut11-eng](https://github.com/adilrajut11-eng)

---

**Made with ❤️ for better healthcare**
