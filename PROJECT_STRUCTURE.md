# Volunteer Squad - Project Structure

## 📁 Directory Layout

```
volunteer-squad/
├── lib/
│   ├── main.dart                 # App entry point & all screens
│   ├── models/
│   │   └── models.dart          # Data models (User, Event, Squad, etc.)
│   ├── services/
│   │   └── firebase_service.dart # Firebase integration & business logic
│   ├── providers/
│   │   └── app_provider.dart    # State management with Provider
│   └── config/
│       └── environment.dart      # Environment configuration
│
├── android/
│   ├── app/
│   │   ├── build.gradle         # Android build configuration
│   │   ├── google-services.json # Firebase Android config
│   │   └── src/
│   │       └── main/
│   │           └── AndroidManifest.xml
│   └── build.gradle
│
├── ios/
│   ├── Runner/
│   │   ├── GoogleService-Info.plist # Firebase iOS config
│   │   └── Info.plist
│   └── Podfile
│
├── web/
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
│
├── test/
│   ├── unit/
│   │   └── firebase_service_test.dart
│   └── widget/
│       └── app_test.dart
│
├── integration_test/
│   └── app_test.dart
│
├── pubspec.yaml                 # Flutter dependencies
├── pubspec.lock                 # Locked dependency versions
├── analysis_options.yaml        # Linter rules
├── .gitignore
├── README.md                    # Project overview
├── FIREBASE_SETUP.md           # Firebase configuration guide
├── TESTING_GUIDE.md            # Testing procedures
├── DEPLOYMENT_GUIDE.md         # Deployment instructions
└── PROJECT_STRUCTURE.md        # This file
```

## 📄 File Descriptions

### Core Application Files

#### `lib/main.dart`
- **Purpose**: Application entry point and main UI
- **Contains**:
  - `VolunteerSquadApp`: Main app widget with theme configuration
  - `AuthScreen`: Sign up/Sign in interface
  - `MainNavigator`: Bottom navigation and screen routing
  - `HomeFeedScreen`: Event discovery and creation
  - `LeaderboardScreen`: Global rankings
  - `ImpactDashboardScreen`: Personal impact tracking
  - `SquadsScreen`: Squad management
  - `ProfileScreen`: User profile and settings
  - `AppColors`: Color palette constants
  - `ModernBackground`: Reusable background widget

#### `lib/models/models.dart`
- **Purpose**: Data model definitions
- **Contains**:
  - `VolunteerUser`: User profile data
  - `VolunteerEvent`: Event information
  - `Squad`: Squad/group data
  - `ImpactRecord`: Volunteer hours log
  - `Badge`: Achievement definitions
  - Firestore serialization methods

#### `lib/services/firebase_service.dart`
- **Purpose**: Firebase integration and business logic
- **Contains**:
  - Authentication methods (sign up, sign in, sign out)
  - User management (CRUD operations)
  - Event management (create, retrieve, register)
  - Skill-based matching algorithm
  - Impact tracking and hour logging
  - Leaderboard queries
  - Squad management
  - Helper methods for level/badge calculation

#### `lib/providers/app_provider.dart`
- **Purpose**: State management using Provider pattern
- **Contains**:
  - `AppProvider`: Main state management class
  - User state (current user, authentication)
  - Event state (all events, matched events)
  - Leaderboard state
  - Squad state
  - Loading and error states
  - Methods for all user actions

### Configuration Files

#### `pubspec.yaml`
- **Purpose**: Flutter project configuration and dependencies
- **Key Dependencies**:
  - `flutter`: Core framework
  - `provider`: State management
  - `firebase_core`: Firebase initialization
  - `firebase_auth`: Authentication
  - `cloud_firestore`: Database
  - `firebase_storage`: File storage
  - `uuid`: Unique ID generation
  - `intl`: Internationalization

#### `analysis_options.yaml`
- **Purpose**: Dart linter configuration
- **Enforces**: Code style and best practices

### Platform-Specific Files

#### Android Configuration
- `android/app/build.gradle`: Build settings, signing config
- `android/app/google-services.json`: Firebase credentials
- `android/app/src/main/AndroidManifest.xml`: App permissions

#### iOS Configuration
- `ios/Runner/GoogleService-Info.plist`: Firebase credentials
- `ios/Runner/Info.plist`: App configuration
- `ios/Podfile`: CocoaPods dependencies

#### Web Configuration
- `web/index.html`: HTML entry point
- `web/manifest.json`: PWA manifest
- `web/favicon.png`: App icon

### Testing Files

#### `test/` Directory
- Unit tests for services and utilities
- Widget tests for UI components
- Mock Firebase for testing

#### `integration_test/` Directory
- End-to-end tests
- User flow testing
- Real Firebase integration testing

### Documentation Files

#### `README.md`
- Project overview
- Feature descriptions
- Getting started guide
- Tech stack information

#### `FIREBASE_SETUP.md`
- Step-by-step Firebase configuration
- Security rules
- Troubleshooting guide

#### `TESTING_GUIDE.md`
- Test scenarios and checklists
- Manual testing procedures
- Unit and integration test examples
- Bug reporting template

#### `DEPLOYMENT_GUIDE.md`
- Android deployment (APK, App Bundle)
- iOS deployment (App Store)
- Web deployment (Firebase Hosting)
- CI/CD pipeline setup
- Production configuration

## 🏗️ Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)          │
│  - AuthScreen                       │
│  - HomeFeedScreen                   │
│  - LeaderboardScreen                │
│  - ImpactDashboardScreen            │
│  - SquadsScreen                     │
│  - ProfileScreen                    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    State Management (Provider)      │
│  - AppProvider                      │
│  - State management logic           │
│  - User actions coordination        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    Business Logic (Services)        │
│  - FirebaseService                  │
│  - Matching algorithm               │
│  - Data processing                  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    Data Layer (Firebase)            │
│  - Authentication                   │
│  - Firestore Database               │
│  - Cloud Storage                    │
└─────────────────────────────────────┘
```

### Data Flow

```
User Action (UI)
    ↓
Provider Method Called
    ↓
Firebase Service Method Called
    ↓
Firebase Operation
    ↓
Data Updated in Firestore
    ↓
Provider State Updated
    ↓
UI Rebuilt with New Data
```

## 🔄 Key Workflows

### Authentication Flow
1. User enters email/password
2. `AuthScreen` calls `AppProvider.signUp()` or `signIn()`
3. `AppProvider` calls `FirebaseService.signUpWithEmail()` or `signInWithEmail()`
4. Firebase creates user and saves to Firestore
5. `AppProvider` loads user data
6. UI navigates to `MainNavigator`

### Event Discovery Flow
1. `HomeFeedScreen` loads on app start
2. `MainNavigator.initState()` calls `AppProvider.loadAllEvents()`
3. `AppProvider` calls `FirebaseService.getAllEvents()`
4. For volunteers: `FirebaseService.getMatchedEventsForVolunteer()` scores events
5. Events displayed sorted by match score
6. User taps event to see details
7. User can register/unregister

### Impact Tracking Flow
1. User logs hours from `ImpactDashboardScreen`
2. `AppProvider.logImpactHours()` called
3. `FirebaseService.logImpactHours()` creates impact record
4. User's total hours updated
5. Level and badges recalculated
6. `AppProvider` reloads user data
7. UI updates with new stats

### Squad Management Flow
1. User creates squad from `SquadsScreen`
2. `AppProvider.createSquad()` called
3. `FirebaseService.createSquad()` creates squad with invite code
4. Squad added to user's joined squads
5. Other users join with invite code
6. `FirebaseService.joinSquad()` adds user to squad
7. Squad impact hours calculated from member totals

## 📊 Database Schema

### Collections Structure

```
Firestore Database
├── users/
│   └── {userId}/
│       ├── name: String
│       ├── email: String
│       ├── skills: Array<String>
│       ├── totalHours: Number
│       ├── level: Number
│       ├── unlockedBadges: Array<String>
│       ├── joinedSquads: Array<String>
│       ├── userType: String
│       └── createdAt: Timestamp
│
├── events/
│   └── {eventId}/
│       ├── title: String
│       ├── organizationId: String
│       ├── description: String
│       ├── requiredSkills: Array<String>
│       ├── eventDate: Timestamp
│       ├── location: String
│       ├── totalSlots: Number
│       ├── filledSlots: Number
│       ├── registeredVolunteers: Array<String>
│       ├── estimatedHours: Number
│       └── createdAt: Timestamp
│
├── squads/
│   └── {squadId}/
│       ├── name: String
│       ├── description: String
│       ├── creatorId: String
│       ├── memberIds: Array<String>
│       ├── inviteCode: String
│       ├── totalImpactHours: Number
│       └── createdAt: Timestamp
│
└── impact_records/
    └── {recordId}/
        ├── volunteerId: String
        ├── eventId: String
        ├── hoursLogged: Number
        ├── loggedAt: Timestamp
        └── notes: String
```

## 🎨 UI Component Hierarchy

```
VolunteerSquadApp
├── AuthScreen
│   ├── TextField (email)
│   ├── TextField (password)
│   ├── DropdownButton (user type)
│   └── ElevatedButton (submit)
│
└── MainNavigator
    ├── HomeFeedScreen
    │   ├── AppBar
    │   ├── ListView (events)
    │   │   └── EventCard
    │   │       ├── Icon
    │   │       ├── Text (title)
    │   │       ├── LinearProgressIndicator
    │   │       └── Wrap (tags)
    │   └── FloatingActionButton
    │
    ├── LeaderboardScreen
    │   ├── AppBar
    │   └── ListView (users)
    │       └── LeaderboardCard
    │           ├── Rank
    │           ├── Avatar
    │           ├── Name
    │           └── Hours
    │
    ├── ImpactDashboardScreen
    │   ├── AppBar
    │   ├── ImpactCard
    │   │   ├── Total Hours
    │   │   ├── ProgressBar
    │   │   └── Next Tier Info
    │   └── BadgeGrid
    │       └── BadgeCard (x5)
    │
    ├── SquadsScreen
    │   ├── AppBar
    │   └── ListView (squads)
    │       └── SquadCard
    │           ├── Name
    │           ├── Members
    │           ├── Hours
    │           └── Invite Code
    │
    └── ProfileScreen
        ├── AppBar
        ├── ProfileHeader
        │   ├── Avatar
        │   ├── Name
        │   └── Email
        ├── StatsRow
        │   ├── Hours Card
        │   └── Level Card
        ├── SkillsSection
        │   └── SkillTag (x multiple)
        └── ActionButtons
            ├── Update Skills
            └── Sign Out
```

## 🔐 Security Considerations

### Authentication
- Firebase Authentication handles password hashing
- Email verification recommended for production
- Session management handled by Firebase

### Data Access
- Firestore security rules enforce user-level access
- Users can only modify their own data
- Organizations can only modify their own events

### API Security
- All API calls go through Firebase
- No sensitive data in client code
- Environment variables for configuration

## 📈 Scalability Considerations

### Current Limitations
- Firestore read/write limits
- Real-time listener limits
- Storage limits

### Future Optimizations
- Implement pagination for large lists
- Add caching layer
- Optimize Firestore queries with indexes
- Implement Cloud Functions for heavy operations
- Add CDN for static assets

## 🚀 Performance Optimization

### Current Optimizations
- Lazy loading of screens
- Efficient state management with Provider
- Firestore query optimization
- Image caching

### Future Improvements
- Implement offline-first architecture
- Add service workers for web
- Optimize bundle size
- Implement code splitting
- Add performance monitoring

---

**Last Updated**: 2024
**Version**: 1.0
