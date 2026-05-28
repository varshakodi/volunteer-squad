# Volunteer Squad - Testing Guide

## 🧪 Testing Overview

This guide covers all testing scenarios for the Volunteer Squad application, including unit tests, integration tests, and manual testing procedures.

## 📋 Test Scenarios

### 1. Authentication Tests

#### Sign Up Flow
- [ ] User can sign up with valid email and password
- [ ] User can select "Volunteer" or "Organization" type
- [ ] Error message shown for invalid email format
- [ ] Error message shown for weak password
- [ ] Error message shown for existing email
- [ ] User data saved to Firestore after sign up
- [ ] User redirected to main app after successful sign up

#### Sign In Flow
- [ ] User can sign in with correct credentials
- [ ] Error message shown for incorrect password
- [ ] Error message shown for non-existent email
- [ ] User redirected to main app after successful sign in
- [ ] User stays logged in after app restart

#### Sign Out
- [ ] User can sign out from profile screen
- [ ] User redirected to auth screen after sign out
- [ ] User data cleared from local storage

### 2. Event Management Tests

#### Event Discovery (Volunteer)
- [ ] Volunteer sees matched events based on skills
- [ ] Events sorted by match score
- [ ] Event details display correctly
- [ ] Slot availability shown accurately
- [ ] "Event Full" indicator appears when slots full
- [ ] Can scroll through event list

#### Event Creation (Organization)
- [ ] Organization can create new event
- [ ] Event title is required
- [ ] Event description is required
- [ ] Location field is required
- [ ] Total slots field accepts numbers only
- [ ] Estimated hours field accepts numbers only
- [ ] Event appears in event list after creation
- [ ] Event data saved to Firestore

#### Event Registration
- [ ] Volunteer can register for event
- [ ] Registration button changes to "Cancel Registration"
- [ ] Slot count increases after registration
- [ ] Volunteer can unregister from event
- [ ] Slot count decreases after unregistration
- [ ] Cannot register if event is full
- [ ] Cannot register twice for same event

### 3. Skill-Based Matching Tests

#### Skill Selection
- [ ] Volunteer can select multiple skills
- [ ] Skills saved to user profile
- [ ] Skills persist after app restart
- [ ] Can update skills anytime

#### Matching Algorithm
- [ ] Events with matching skills ranked higher
- [ ] Events without matching skills ranked lower
- [ ] Unregistered events ranked higher
- [ ] Events with available slots ranked higher
- [ ] Matching score calculated correctly

### 4. Impact Tracking Tests

#### Impact Dashboard
- [ ] Total hours displayed correctly
- [ ] Progress bar shows correct percentage
- [ ] Next tier name displayed
- [ ] Hours to next tier calculated correctly
- [ ] Current level displayed

#### Badge System
- [ ] First Step badge unlocked at 1 hour
- [ ] Committed badge unlocked at 50 hours
- [ ] Leader badge unlocked at 100 hours
- [ ] Hero badge unlocked at 250 hours
- [ ] Legend badge unlocked at 500 hours
- [ ] Locked badges shown as grayed out
- [ ] Unlocked badges shown with glow effect

#### Level System
- [ ] Level 1 (Starter) at 0-49 hours
- [ ] Level 2 (Bronze) at 50-99 hours
- [ ] Level 3 (Silver) at 100-249 hours
- [ ] Level 4 (Gold) at 250-499 hours
- [ ] Level 5 (Legend) at 500+ hours

### 5. Leaderboard Tests

#### Global Rankings
- [ ] Leaderboard displays all volunteers
- [ ] Sorted by total hours (descending)
- [ ] Current user highlighted
- [ ] Top 3 users have medal icons
- [ ] Top 3 users have colored borders
- [ ] Rank numbers displayed correctly
- [ ] Hours displayed correctly

#### Real-Time Updates
- [ ] Leaderboard updates when hours logged
- [ ] Rankings change when user surpasses another
- [ ] New users appear in leaderboard

### 6. Squad Management Tests

#### Squad Creation
- [ ] User can create new squad
- [ ] Squad name is required
- [ ] Squad description is required
- [ ] Squad appears in user's squad list
- [ ] Creator is added as first member
- [ ] Invite code generated automatically
- [ ] Squad data saved to Firestore

#### Squad Joining
- [ ] User can join squad with invite code
- [ ] Error shown for invalid code
- [ ] User added to squad members
- [ ] Squad appears in user's squad list
- [ ] Cannot join same squad twice

#### Squad Display
- [ ] Squad name displayed
- [ ] Squad description displayed
- [ ] Member count shown
- [ ] Total impact hours shown
- [ ] Invite code displayed
- [ ] Can copy invite code

#### Squad Networking
- [ ] Multiple users can join same squad
- [ ] Squad members can see each other
- [ ] Collective impact hours calculated
- [ ] Squad invite code is unique

### 7. Profile Management Tests

#### Profile Display
- [ ] User name displayed
- [ ] User email displayed
- [ ] User type displayed (Volunteer/Organization)
- [ ] Profile picture placeholder shown
- [ ] Total hours displayed
- [ ] Current level displayed

#### Skill Management (Volunteer)
- [ ] Can add skills from predefined list
- [ ] Can remove skills
- [ ] Skills displayed as tags
- [ ] Skills persist after app restart
- [ ] Skill selection updates matching

#### Profile Updates
- [ ] Can update profile information
- [ ] Changes saved to Firestore
- [ ] Changes reflected immediately

### 8. UI/UX Tests

#### Dark Mode
- [ ] All screens use dark theme
- [ ] Text is readable on dark background
- [ ] Accent colors (purple, cyan) visible
- [ ] No harsh contrasts

#### Navigation
- [ ] Bottom navigation bar visible on all screens
- [ ] Can switch between all 5 tabs
- [ ] Current tab highlighted
- [ ] Navigation state preserved

#### Responsiveness
- [ ] App works on different screen sizes
- [ ] Text scales appropriately
- [ ] Buttons are easily tappable
- [ ] No content overflow

#### Loading States
- [ ] Loading spinner shown while fetching data
- [ ] Buttons disabled during loading
- [ ] Error messages displayed clearly

### 9. Data Persistence Tests

#### Firestore Sync
- [ ] User data synced to Firestore
- [ ] Event data synced to Firestore
- [ ] Squad data synced to Firestore
- [ ] Impact records synced to Firestore
- [ ] Data retrieved correctly from Firestore

#### Offline Functionality
- [ ] App shows cached data when offline
- [ ] Changes queued when offline
- [ ] Changes synced when back online

### 10. Performance Tests

#### Load Times
- [ ] App launches in < 3 seconds
- [ ] Event list loads in < 2 seconds
- [ ] Leaderboard loads in < 2 seconds
- [ ] Profile loads in < 1 second

#### Memory Usage
- [ ] App doesn't crash with large event lists
- [ ] App doesn't crash with many squads
- [ ] Memory usage stays reasonable

## 🔍 Manual Testing Checklist

### Pre-Testing Setup
- [ ] Firebase project created and configured
- [ ] Android/iOS configuration files added
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App builds successfully (`flutter build apk` or `flutter build ios`)

### Testing Procedure

1. **Fresh Install Test**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Sign Up Test**
   - Sign up as volunteer
   - Sign up as organization
   - Verify data in Firestore

3. **Event Flow Test**
   - Create event (as organization)
   - Register for event (as volunteer)
   - Log hours
   - Check impact dashboard

4. **Squad Flow Test**
   - Create squad
   - Get invite code
   - Join squad with another account
   - Verify collective hours

5. **Leaderboard Test**
   - Log hours for multiple users
   - Verify ranking order
   - Check real-time updates

## 🧬 Unit Tests

Create `test/` directory and add tests:

```dart
// test/firebase_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_squad/services/firebase_service.dart';

void main() {
  group('FirebaseService', () {
    test('calculateLevel returns correct level', () {
      final service = FirebaseService();
      expect(service.calculateLevel(0), 1);
      expect(service.calculateLevel(50), 2);
      expect(service.calculateLevel(100), 3);
      expect(service.calculateLevel(250), 4);
      expect(service.calculateLevel(500), 5);
    });

    test('calculateBadges returns correct badges', () {
      final service = FirebaseService();
      expect(service.calculateBadges(1, []), contains('first_step'));
      expect(service.calculateBadges(50, []), contains('committed'));
      expect(service.calculateBadges(100, []), contains('leader'));
    });
  });
}
```

Run tests:
```bash
flutter test
```

## 🔗 Integration Tests

Create `integration_test/` directory:

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_squad/main.dart';

void main() {
  group('Volunteer Squad Integration Tests', () {
    testWidgets('Sign up and create event', (WidgetTester tester) async {
      await tester.pumpWidget(const VolunteerSquadApp());
      
      // Sign up
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Verify logged in
      expect(find.byType(MainNavigator), findsOneWidget);
    });
  });
}
```

Run integration tests:
```bash
flutter test integration_test/app_test.dart
```

## 📊 Test Coverage

Generate coverage report:
```bash
flutter test --coverage
```

View coverage:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🐛 Bug Reporting Template

When testing, use this template for bug reports:

```
**Title**: [Brief description]

**Severity**: Critical / High / Medium / Low

**Steps to Reproduce**:
1. 
2. 
3. 

**Expected Result**:

**Actual Result**:

**Screenshots/Videos**:

**Device Info**:
- OS: Android / iOS
- Version: 
- Device Model:

**Additional Context**:
```

## ✅ Sign-Off Checklist

Before release:
- [ ] All manual tests passed
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] No critical bugs
- [ ] Performance acceptable
- [ ] UI/UX verified
- [ ] Firebase rules tested
- [ ] Error handling verified
- [ ] Data persistence verified
- [ ] Security review completed

## 📞 Support

For testing issues, contact the development team or open an issue on GitHub.

---

**Last Updated**: 2024
**Version**: 1.0
