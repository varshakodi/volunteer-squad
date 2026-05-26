# Volunteer Squad - Quick Reference Guide

## 🚀 Quick Start

### Installation
```bash
# Clone repository
git clone https://github.com/varshakodi/volunteer-squad.git
cd volunteer-squad

# Install dependencies
flutter pub get

# Configure Firebase (see FIREBASE_SETUP.md)

# Run app
flutter run
```

## 📱 App Navigation

### Bottom Navigation Tabs
1. **Events** (Explore) - Discover and create events
2. **Ranks** (Leaderboard) - View global rankings
3. **Impact** (Dashboard) - Track personal impact
4. **Squads** (Community) - Manage squads
5. **Profile** (Settings) - User profile

## 👤 User Types

### Volunteer
- Browse matched events
- Register for events
- Log volunteer hours
- Track impact
- Join squads
- View skills

### Organization
- Create events
- Set required skills
- Define volunteer slots
- View registrations
- Track event participation

## 🎮 Key Features

### Event Discovery
- **Skill-Based Matching**: Events ranked by skill match
- **Slot Tracking**: See available volunteer slots
- **Event Details**: View full event information
- **Quick Register**: One-tap event registration

### Impact Tracking
- **Hours Logged**: Total volunteer hours
- **Progress Bar**: Visual progress to next tier
- **Badges**: Unlock achievements
- **Levels**: Advance through tiers

### Squads
- **Create Squad**: Start a volunteer group
- **Invite Code**: Share unique code with peers
- **Member Tracking**: See squad members
- **Collective Hours**: Track squad impact

### Leaderboard
- **Global Rankings**: See top volunteers
- **Medal Display**: Top 3 highlighted
- **Your Rank**: Find yourself on leaderboard
- **Real-Time Updates**: Live ranking changes

## 🔐 Authentication

### Sign Up
1. Enter email
2. Enter password
3. Select user type (Volunteer/Organization)
4. Create account

### Sign In
1. Enter email
2. Enter password
3. Sign in

### Sign Out
- Go to Profile tab
- Tap "Sign Out" button

## 📊 Data Models

### User
```
- name: String
- email: String
- skills: List<String>
- totalHours: int
- level: int (1-5)
- unlockedBadges: List<String>
- joinedSquads: List<String>
- userType: 'volunteer' | 'organization'
```

### Event
```
- title: String
- description: String
- location: String
- requiredSkills: List<String>
- totalSlots: int
- filledSlots: int
- registeredVolunteers: List<String>
- estimatedHours: int
```

### Squad
```
- name: String
- description: String
- memberIds: List<String>
- inviteCode: String
- totalImpactHours: int
```

## 🎯 Common Tasks

### As a Volunteer

#### Find Events
1. Go to Events tab
2. Browse matched events (sorted by skill match)
3. Tap event to see details
4. Tap "Volunteer Now" to register

#### Log Hours
1. Go to Impact tab
2. View your current hours
3. Log hours after volunteering
4. Watch badges unlock

#### Join Squad
1. Go to Squads tab
2. Tap "Join Squad"
3. Enter invite code
4. Join squad

#### Update Skills
1. Go to Profile tab
2. Tap "Update Skills"
3. Select/deselect skills
4. Tap "Done"

### As an Organization

#### Create Event
1. Go to Events tab
2. Tap "Host Event" button
3. Fill in event details
4. Set required skills
5. Define volunteer slots
6. Publish event

#### View Registrations
1. Go to Events tab
2. Tap event to see details
3. View registered volunteers

## 🏆 Gamification

### Badges
| Badge | Hours | Icon |
|-------|-------|------|
| First Step | 1 | 🐾 |
| Committed | 50 | ⏱️ |
| Leader | 100 | ⭐ |
| Hero | 250 | 🚀 |
| Legend | 500 | 💎 |

### Levels
| Level | Hours | Name |
|-------|-------|------|
| 1 | 0-49 | Starter |
| 2 | 50-99 | Bronze |
| 3 | 100-249 | Silver |
| 4 | 250-499 | Gold |
| 5 | 500+ | Legend |

## 🔧 Troubleshooting

### App Won't Start
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Not Working
- Check Firebase configuration files
- Verify internet connection
- Check Firebase Console for errors

### Events Not Showing
- Ensure you're signed in
- Check internet connection
- Refresh by navigating away and back

### Can't Register for Event
- Event might be full
- You might already be registered
- Check internet connection

## 📞 Support

### Getting Help
1. Check documentation files
2. Review error messages
3. Check Firebase Console logs
4. Contact support team

### Reporting Issues
- Describe the problem
- Include steps to reproduce
- Attach screenshots
- Note device/OS version

## 🔗 Important Links

- [Firebase Console](https://console.firebase.google.com)
- [Flutter Documentation](https://flutter.dev/docs)
- [GitHub Repository](https://github.com/varshakodi/volunteer-squad)
- [Project Documentation](./README.md)

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| README.md | Project overview |
| FIREBASE_SETUP.md | Firebase configuration |
| TESTING_GUIDE.md | Testing procedures |
| DEPLOYMENT_GUIDE.md | Deployment instructions |
| PROJECT_STRUCTURE.md | Project architecture |
| IMPLEMENTATION_SUMMARY.md | Implementation details |
| QUICK_REFERENCE.md | This file |

## 💡 Tips & Tricks

### Maximize Impact
- Add all relevant skills to your profile
- Register for events matching your skills
- Log hours consistently
- Join squads for collective impact

### Find Best Events
- Events are ranked by skill match
- Check estimated hours
- Look for events with available slots
- Read event descriptions carefully

### Build Your Squad
- Create squad with clear purpose
- Share invite code with peers
- Coordinate volunteer efforts
- Track collective impact

### Climb Leaderboard
- Log hours after each volunteer session
- Participate in multiple events
- Join squads for bonus opportunities
- Unlock badges for recognition

## 🎨 UI Shortcuts

### Navigation
- Tap bottom navigation to switch tabs
- Tap back button to go back
- Swipe to dismiss modals

### Event Details
- Tap event card to see full details
- Tap "Volunteer Now" to register
- Tap "Cancel Registration" to unregister

### Profile
- Tap "Update Skills" to manage skills
- Tap "Sign Out" to log out

## 🔐 Security Tips

### Protect Your Account
- Use strong password
- Don't share login credentials
- Sign out on shared devices
- Keep email updated

### Data Privacy
- Your data is encrypted
- Only you can see your profile
- Organizations see only registered volunteers
- Squads are private to members

## 📈 Performance Tips

### Faster Loading
- Close other apps
- Check internet connection
- Clear app cache if needed
- Update to latest version

### Better Experience
- Use WiFi when possible
- Keep app updated
- Report bugs to help improve
- Provide feedback

## 🎓 Learning Resources

### For New Users
- Read README.md
- Follow in-app tutorials
- Check TESTING_GUIDE.md for examples
- Ask support team

### For Developers
- Review PROJECT_STRUCTURE.md
- Check FIREBASE_SETUP.md
- Read code comments
- Review DEPLOYMENT_GUIDE.md

## 🚀 Next Steps

1. **Setup**: Configure Firebase (FIREBASE_SETUP.md)
2. **Test**: Run tests (TESTING_GUIDE.md)
3. **Deploy**: Deploy app (DEPLOYMENT_GUIDE.md)
4. **Monitor**: Track usage and feedback
5. **Improve**: Implement Phase 2 features

## 📋 Checklist

### Before First Use
- [ ] Install Flutter
- [ ] Clone repository
- [ ] Install dependencies
- [ ] Configure Firebase
- [ ] Run app

### Before Deployment
- [ ] All tests passing
- [ ] Firebase rules updated
- [ ] Version number updated
- [ ] Screenshots prepared
- [ ] Release notes written

### After Deployment
- [ ] Monitor crash reports
- [ ] Check analytics
- [ ] Respond to user feedback
- [ ] Plan next features

---

**Last Updated**: 2024
**Version**: 1.0

**Need help? Check the documentation files or contact support!**
