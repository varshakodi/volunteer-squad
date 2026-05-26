# Firebase Setup Guide for Volunteer Squad

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: "Volunteer Squad"
4. Accept terms and create project
5. Wait for project to be created

## Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Select **Email/Password** provider
4. Enable it and save
5. (Optional) Enable Google Sign-In for future enhancement

## Step 3: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Select **Start in test mode** (for development)
4. Choose region closest to you
5. Click **Enable**

### Firestore Security Rules (for production)

Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Events are readable by all authenticated users
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.organizationId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.organizationId == request.auth.uid;
    }
    
    // Squads
    match /squads/{squadId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && resource.data.creatorId == request.auth.uid;
    }
    
    // Impact records
    match /impact_records/{recordId} {
      allow read, write: if request.auth != null && request.resource.data.volunteerId == request.auth.uid;
    }
  }
}
```

## Step 4: Configure Android

1. In Firebase Console, go to **Project Settings**
2. Click **Add App** → **Android**
3. Enter package name: `com.example.volunteer_squad`
4. Download `google-services.json`
5. Place it in: `android/app/google-services.json`

### Update android/build.gradle

Add to dependencies:
```gradle
classpath 'com.google.gms:google-services:4.3.15'
```

### Update android/app/build.gradle

Add at the end:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 5: Configure iOS

1. In Firebase Console, go to **Project Settings**
2. Click **Add App** → **iOS**
3. Enter bundle ID: `com.example.volunteerSquad`
4. Download `GoogleService-Info.plist`
5. Open Xcode: `open ios/Runner.xcworkspace`
6. Drag `GoogleService-Info.plist` into Xcode (check "Copy items if needed")

## Step 6: Update Flutter Project

### pubspec.yaml

Ensure these dependencies are included:
```yaml
dependencies:
  firebase_core: ^3.1.0
  firebase_auth: ^5.1.0
  cloud_firestore: ^5.1.0
  firebase_storage: ^12.1.0
  provider: ^6.1.5+1
  uuid: ^4.0.0
  intl: ^0.19.0
```

Run:
```bash
flutter pub get
```

## Step 7: Initialize Firebase in Code

The app already initializes Firebase in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.initialize();
  // ...
}
```

## Step 8: Create Firestore Collections

You can create collections manually or they'll be auto-created when data is first written.

### Manual Creation (Optional)

1. Go to Firestore Database
2. Click **Start Collection**
3. Create these collections:
   - `users`
   - `events`
   - `squads`
   - `impact_records`

## Step 9: Test the Setup

1. Run the app:
   ```bash
   flutter run
   ```

2. Sign up with a test account
3. Check Firebase Console → Firestore to see data being written
4. Create an event and verify it appears in Firestore

## Troubleshooting

### "Firebase not initialized" error
- Ensure `await Firebase.initializeApp()` is called in `main()`
- Check that `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are properly placed

### Authentication not working
- Verify Email/Password provider is enabled in Firebase Console
- Check Firestore rules allow authentication

### Firestore write errors
- Check Firestore security rules
- Verify user is authenticated
- Check browser console for detailed error messages

### iOS build issues
- Run `flutter clean`
- Delete `ios/Pods` and `ios/Podfile.lock`
- Run `flutter pub get`
- Run `flutter run`

## Environment Variables (Optional)

Create `.env` file for sensitive data:
```
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## Next Steps

1. **Enable Storage** (for profile images):
   - Go to Firebase Console → Storage
   - Create bucket
   - Update security rules

2. **Set up Cloud Functions** (for advanced features):
   - Automated notifications
   - Email confirmations
   - Data aggregation

3. **Enable Analytics**:
   - Go to Firebase Console → Analytics
   - Track user engagement

4. **Set up Hosting** (for web version):
   - Go to Firebase Console → Hosting
   - Deploy web app

## Production Checklist

- [ ] Update Firestore security rules
- [ ] Enable reCAPTCHA for authentication
- [ ] Set up email verification
- [ ] Configure password reset
- [ ] Enable backup and disaster recovery
- [ ] Set up monitoring and alerts
- [ ] Review and optimize Firestore indexes
- [ ] Test on real devices
- [ ] Set up CI/CD pipeline

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Plugin](https://firebase.flutter.dev/)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)

---

For more help, visit the [Firebase Support](https://firebase.google.com/support) page.
