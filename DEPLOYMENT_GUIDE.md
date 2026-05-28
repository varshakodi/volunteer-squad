# Volunteer Squad - Deployment Guide

## 🚀 Deployment Overview

This guide covers deploying Volunteer Squad to Android, iOS, and Web platforms.

## 📱 Android Deployment

### Prerequisites
- Android Studio installed
- Android SDK configured
- Keystore file for signing

### Step 1: Create Keystore

```bash
keytool -genkey -v -keystore ~/volunteer_squad.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias volunteer_squad
```

### Step 2: Configure Signing

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=volunteer_squad
storeFile=/path/to/volunteer_squad.keystore
```

Update `android/app/build.gradle`:
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 3: Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 4: Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 5: Upload to Google Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app
3. Fill in app details
4. Upload App Bundle
5. Add screenshots and description
6. Set pricing and distribution
7. Submit for review

## 🍎 iOS Deployment

### Prerequisites
- Xcode installed
- Apple Developer account
- iOS certificates and provisioning profiles

### Step 1: Configure iOS Project

```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select Runner project
2. Go to Signing & Capabilities
3. Select team
4. Update bundle identifier: `com.example.volunteersquad`

### Step 2: Update Version

In `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

In Xcode:
- Version: 1.0.0
- Build: 1

### Step 3: Build for Release

```bash
flutter build ios --release
```

### Step 4: Create Archive

```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select "Any iOS Device (arm64)"
2. Product → Archive
3. Distribute App
4. Select "App Store Connect"
5. Upload

### Step 5: Submit to App Store

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app
3. Fill in app information
4. Upload build
5. Add screenshots and description
6. Set pricing and availability
7. Submit for review

## 🌐 Web Deployment

### Step 1: Build Web

```bash
flutter build web --release
```

Output: `build/web/`

### Step 2: Deploy to Firebase Hosting

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
```

Select:
- Use existing project
- Public directory: `build/web`
- Configure as single-page app: Yes

Deploy:
```bash
firebase deploy --only hosting
```

### Step 3: Deploy to Other Platforms

#### Netlify
```bash
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

#### Vercel
```bash
npm install -g vercel
vercel --prod
```

## 🔐 Production Configuration

### Firebase Security Rules

Update Firestore rules for production:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Events are readable by authenticated users
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.resource.data.organizationId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.organizationId == request.auth.uid;
    }
    
    // Squads
    match /squads/{squadId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                               resource.data.creatorId == request.auth.uid;
    }
    
    // Impact records
    match /impact_records/{recordId} {
      allow read, write: if request.auth != null && 
                            request.resource.data.volunteerId == request.auth.uid;
    }
  }
}
```

### Environment Configuration

Create `lib/config/environment.dart`:

```dart
class Environment {
  static const String apiUrl = 'https://api.volunteersquad.com';
  static const String appName = 'Volunteer Squad';
  static const String appVersion = '1.0.0';
  static const bool isProduction = true;
}
```

### Error Tracking

Add Sentry for error tracking:

```yaml
dependencies:
  sentry_flutter: ^7.0.0
```

Initialize in `main.dart`:

```dart
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const VolunteerSquadApp()),
  );
}
```

## 📊 Monitoring & Analytics

### Firebase Analytics

Already integrated. Track custom events:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log event
await analytics.logEvent(
  name: 'volunteer_registered',
  parameters: {
    'event_id': eventId,
    'user_id': userId,
  },
);
```

### Performance Monitoring

```dart
import 'package:firebase_performance/firebase_performance.dart';

final performance = FirebasePerformance.instance;

// Create trace
final trace = performance.newTrace('event_creation');
await trace.start();
// ... do work
await trace.stop();
```

## 🔄 CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.11.5'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_KEY }}
          packageName: com.example.volunteersquad
          releaseFiles: build/app/outputs/flutter-apk/app-release.apk
          track: internal
```

## 📋 Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Code reviewed
- [ ] Firebase rules updated
- [ ] Environment variables set
- [ ] Version number updated
- [ ] Release notes prepared
- [ ] Screenshots updated
- [ ] Privacy policy reviewed
- [ ] Terms of service reviewed
- [ ] Analytics configured
- [ ] Error tracking configured
- [ ] Performance monitoring enabled
- [ ] Backup and recovery plan in place

## 🚨 Post-Deployment

### Monitoring
- [ ] Monitor crash reports
- [ ] Check analytics
- [ ] Monitor performance metrics
- [ ] Check user feedback

### Rollback Plan
If critical issues found:

1. **Immediate Actions**
   - Disable affected features
   - Post-incident communication
   - Gather logs and data

2. **Rollback**
   - Deploy previous stable version
   - Notify users
   - Investigate root cause

3. **Recovery**
   - Fix issues
   - Test thoroughly
   - Deploy fix

## 📞 Support

For deployment issues:
- Check Firebase Console logs
- Review Sentry error reports
- Check GitHub Actions logs
- Contact support team

## 🔗 Useful Links

- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Firebase Console](https://console.firebase.google.com)
- [GitHub Actions](https://github.com/features/actions)

---

**Last Updated**: 2024
**Version**: 1.0
