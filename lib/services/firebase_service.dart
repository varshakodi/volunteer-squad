import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import 'dart:developer' as developer;

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==========================================
  // AUTHENTICATION
  // ==========================================

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      developer.log('Firebase initialization', error: e);
    }
  }

  /// Validates email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength (min 8 chars, uppercase, lowercase, number)
  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  /// Sanitizes user input to prevent injection attacks
  String _sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  Future<UserCredential?> signUpWithEmail(String email, String password, String name, String userType) async {
    try {
      // Validate inputs
      if (!_isValidEmail(email)) {
        developer.log('Invalid email format');
        return null;
      }
      if (!_isStrongPassword(password)) {
        developer.log('Password does not meet strength requirements');
        return null;
      }
      if (name.isEmpty || name.length > 100) {
        developer.log('Invalid name length');
        return null;
      }
      if (userType != 'volunteer' && userType != 'organization') {
        developer.log('Invalid user type');
        return null;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      final sanitizedName = _sanitizeInput(name);

      final user = VolunteerUser(
        id: userCredential.user!.uid,
        name: sanitizedName,
        email: email.toLowerCase().trim(),
        profileImageUrl: '',
        skills: [],
        totalHours: 0,
        level: 1,
        unlockedBadges: [],
        joinedSquads: [],
        createdAt: DateTime.now(),
        userType: userType,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toFirestore());
      return userCredential;
    } catch (e) {
      developer.log('Sign up error', error: e);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      if (!_isValidEmail(email)) {
        developer.log('Invalid email format');
        return null;
      }

      return await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
    } catch (e) {
      developer.log('Sign in error', error: e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ==========================================
  // USER MANAGEMENT
  // ==========================================

  Future<VolunteerUser?> getUserById(String userId) async {
    try {
      // Validate userId format
      if (userId.isEmpty || userId.length > 128) {
        developer.log('Invalid user ID');
        return null;
      }

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return VolunteerUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      developer.log('Get user error', error: e);
      return null;
    }
  }

  Future<void> updateUserSkills(String userId, List<String> skills) async {
    try {
      // Validate inputs
      if (userId.isEmpty) {
        developer.log('Invalid user ID');
        return;
      }
      if (skills.length > 20) {
        developer.log('Too many skills');
        return;
      }

      // Sanitize skills
      final sanitizedSkills = skills.map((s) => _sanitizeInput(s)).toList();

      await _firestore.collection('users').doc(userId).update({'skills': sanitizedSkills});
    } catch (e) {
      developer.log('Update skills error', error: e);
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      if (userId.isEmpty) {
        developer.log('Invalid user ID');
        return;
      }

      // Sanitize all string values
      final sanitizedData = <String, dynamic>{};
      data.forEach((key, value) {
        if (value is String) {
          sanitizedData[key] = _sanitizeInput(value);
        } else {
          sanitizedData[key] = value;
        }
      });

      await _firestore.collection('users').doc(userId).update(sanitizedData);
    } catch (e) {
      developer.log('Update profile error', error: e);
    }
  }

  // ==========================================
  // EVENT MANAGEMENT
  // ==========================================

  Future<String> createEvent(VolunteerEvent event) async {
    try {
      // Validate event data
      if (event.title.isEmpty || event.title.length > 200) {
        developer.log('Invalid event title');
        return '';
      }
      if (event.description.isEmpty || event.description.length > 2000) {
        developer.log('Invalid event description');
        return '';
      }
      if (event.totalSlots <= 0 || event.totalSlots > 1000) {
        developer.log('Invalid slot count');
        return '';
      }
      if (event.estimatedHours <= 0 || event.estimatedHours > 100) {
        developer.log('Invalid hours');
        return '';
      }

      // Sanitize event data
      final sanitizedEvent = VolunteerEvent(
        id: event.id,
        title: _sanitizeInput(event.title),
        organizationId: event.organizationId,
        organizationName: _sanitizeInput(event.organizationName),
        description: _sanitizeInput(event.description),
        requiredSkills: event.requiredSkills.map((s) => _sanitizeInput(s)).toList(),
        eventDate: event.eventDate,
        location: _sanitizeInput(event.location),
        totalSlots: event.totalSlots,
        filledSlots: event.filledSlots,
        registeredVolunteers: event.registeredVolunteers,
        category: _sanitizeInput(event.category),
        estimatedHours: event.estimatedHours,
        createdAt: event.createdAt,
      );

      final docRef = await _firestore.collection('events').add(sanitizedEvent.toFirestore());
      return docRef.id;
    } catch (e) {
      developer.log('Create event error', error: e);
      return '';
    }
  }

  Future<List<VolunteerEvent>> getAllEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .orderBy('createdAt', descending: true)
          .limit(100) // Prevent loading too many documents
          .get();
      return snapshot.docs.map((doc) => VolunteerEvent.fromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Get events error', error: e);
      return [];
    }
  }

  Future<List<VolunteerEvent>> getEventsByOrganization(String organizationId) async {
    try {
      if (organizationId.isEmpty) {
        developer.log('Invalid organization ID');
        return [];
      }

      final snapshot = await _firestore
          .collection('events')
          .where('organizationId', isEqualTo: organizationId)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();
      return snapshot.docs.map((doc) => VolunteerEvent.fromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Get org events error', error: e);
      return [];
    }
  }

  Future<void> registerVolunteerForEvent(String eventId, String volunteerId) async {
    try {
      if (eventId.isEmpty || volunteerId.isEmpty) {
        developer.log('Invalid event or volunteer ID');
        return;
      }

      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        final event = VolunteerEvent.fromFirestore(eventDoc);
        if (!event.registeredVolunteers.contains(volunteerId) && event.filledSlots < event.totalSlots) {
          final updatedVolunteers = [...event.registeredVolunteers, volunteerId];
          await _firestore.collection('events').doc(eventId).update({
            'registeredVolunteers': updatedVolunteers,
            'filledSlots': event.filledSlots + 1,
          });
        }
      }
    } catch (e) {
      developer.log('Register volunteer error', error: e);
    }
  }

  Future<void> unregisterVolunteerFromEvent(String eventId, String volunteerId) async {
    try {
      if (eventId.isEmpty || volunteerId.isEmpty) {
        developer.log('Invalid event or volunteer ID');
        return;
      }

      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        final event = VolunteerEvent.fromFirestore(eventDoc);
        if (event.registeredVolunteers.contains(volunteerId)) {
          final updatedVolunteers = event.registeredVolunteers.where((id) => id != volunteerId).toList();
          await _firestore.collection('events').doc(eventId).update({
            'registeredVolunteers': updatedVolunteers,
            'filledSlots': event.filledSlots - 1,
          });
        }
      }
    } catch (e) {
      developer.log('Unregister volunteer error', error: e);
    }
  }

  // ==========================================
  // SKILL-BASED MATCHING ENGINE
  // ==========================================

  Future<List<VolunteerEvent>> getMatchedEventsForVolunteer(String volunteerId) async {
    try {
      if (volunteerId.isEmpty) {
        developer.log('Invalid volunteer ID');
        return [];
      }

      final userDoc = await _firestore.collection('users').doc(volunteerId).get();
      if (!userDoc.exists) return [];

      final user = VolunteerUser.fromFirestore(userDoc);
      final allEvents = await getAllEvents();

      // Score events based on skill match
      final scoredEvents = allEvents.map((event) {
        int matchScore = 0;
        for (final skill in event.requiredSkills) {
          if (user.skills.contains(skill)) {
            matchScore += 10;
          }
        }
        // Bonus for events not yet registered
        if (!event.registeredVolunteers.contains(volunteerId)) {
          matchScore += 5;
        }
        // Bonus for events with available slots
        if (event.filledSlots < event.totalSlots) {
          matchScore += 3;
        }
        return {'event': event, 'score': matchScore};
      }).toList();

      // Sort by score and return top matches
      scoredEvents.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
      return scoredEvents.map((item) => item['event'] as VolunteerEvent).toList();
    } catch (e) {
      developer.log('Get matched events error', error: e);
      return [];
    }
  }

  // ==========================================
  // IMPACT TRACKING
  // ==========================================

  Future<void> logImpactHours(String volunteerId, String eventId, int hours, String notes) async {
    try {
      // Validate inputs
      if (volunteerId.isEmpty || eventId.isEmpty) {
        developer.log('Invalid volunteer or event ID');
        return;
      }
      if (hours <= 0 || hours > 100) {
        developer.log('Invalid hours value');
        return;
      }
      if (notes.length > 500) {
        developer.log('Notes too long');
        return;
      }

      final impactRecord = ImpactRecord(
        id: const Uuid().v4(),
        volunteerId: volunteerId,
        eventId: eventId,
        hoursLogged: hours,
        loggedAt: DateTime.now(),
        notes: _sanitizeInput(notes),
      );

      await _firestore.collection('impact_records').doc(impactRecord.id).set(impactRecord.toFirestore());

      // Update user's total hours
      final userDoc = await _firestore.collection('users').doc(volunteerId).get();
      if (userDoc.exists) {
        final user = VolunteerUser.fromFirestore(userDoc);
        final newTotalHours = user.totalHours + hours;
        final newLevel = _calculateLevel(newTotalHours);
        final newBadges = _calculateBadges(newTotalHours, user.unlockedBadges);

        await _firestore.collection('users').doc(volunteerId).update({
          'totalHours': newTotalHours,
          'level': newLevel,
          'unlockedBadges': newBadges,
        });
      }
    } catch (e) {
      developer.log('Log impact hours error', error: e);
    }
  }

  Future<List<ImpactRecord>> getImpactRecordsForVolunteer(String volunteerId) async {
    try {
      if (volunteerId.isEmpty) {
        developer.log('Invalid volunteer ID');
        return [];
      }

      final snapshot = await _firestore
          .collection('impact_records')
          .where('volunteerId', isEqualTo: volunteerId)
          .orderBy('loggedAt', descending: true)
          .limit(100)
          .get();
      return snapshot.docs.map((doc) => ImpactRecord.fromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Get impact records error', error: e);
      return [];
    }
  }

  // ==========================================
  // LEADERBOARD
  // ==========================================

  Future<List<VolunteerUser>> getGlobalLeaderboard({int limit = 50}) async {
    try {
      if (limit <= 0 || limit > 500) {
        limit = 50;
      }

      final snapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'volunteer')
          .orderBy('totalHours', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => VolunteerUser.fromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Get leaderboard error', error: e);
      return [];
    }
  }

  // ==========================================
  // SQUADS
  // ==========================================

  Future<String> createSquad(String name, String description, String creatorId) async {
    try {
      // Validate inputs
      if (name.isEmpty || name.length > 100) {
        developer.log('Invalid squad name');
        return '';
      }
      if (description.isEmpty || description.length > 500) {
        developer.log('Invalid squad description');
        return '';
      }
      if (creatorId.isEmpty) {
        developer.log('Invalid creator ID');
        return '';
      }

      final inviteCode = const Uuid().v4().substring(0, 8).toUpperCase();
      final squad = Squad(
        id: const Uuid().v4(),
        name: _sanitizeInput(name),
        description: _sanitizeInput(description),
        creatorId: creatorId,
        memberIds: [creatorId],
        inviteCode: inviteCode,
        totalImpactHours: 0,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('squads').doc(squad.id).set(squad.toFirestore());

      // Add squad to user's joined squads
      final userDoc = await _firestore.collection('users').doc(creatorId).get();
      if (userDoc.exists) {
        final user = VolunteerUser.fromFirestore(userDoc);
        final updatedSquads = [...user.joinedSquads, squad.id];
        await _firestore.collection('users').doc(creatorId).update({'joinedSquads': updatedSquads});
      }

      return squad.id;
    } catch (e) {
      developer.log('Create squad error', error: e);
      return '';
    }
  }

  Future<Squad?> getSquadByInviteCode(String inviteCode) async {
    try {
      if (inviteCode.isEmpty || inviteCode.length > 20) {
        developer.log('Invalid invite code');
        return null;
      }

      final snapshot = await _firestore
          .collection('squads')
          .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return Squad.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      developer.log('Get squad by code error', error: e);
      return null;
    }
  }

  Future<void> joinSquad(String squadId, String volunteerId) async {
    try {
      if (squadId.isEmpty || volunteerId.isEmpty) {
        developer.log('Invalid squad or volunteer ID');
        return;
      }

      final squadDoc = await _firestore.collection('squads').doc(squadId).get();
      if (squadDoc.exists) {
        final squad = Squad.fromFirestore(squadDoc);
        if (!squad.memberIds.contains(volunteerId)) {
          final updatedMembers = [...squad.memberIds, volunteerId];
          await _firestore.collection('squads').doc(squadId).update({'memberIds': updatedMembers});

          // Add squad to user's joined squads
          final userDoc = await _firestore.collection('users').doc(volunteerId).get();
          if (userDoc.exists) {
            final user = VolunteerUser.fromFirestore(userDoc);
            if (!user.joinedSquads.contains(squadId)) {
              final updatedSquads = [...user.joinedSquads, squadId];
              await _firestore.collection('users').doc(volunteerId).update({'joinedSquads': updatedSquads});
            }
          }
        }
      }
    } catch (e) {
      developer.log('Join squad error', error: e);
    }
  }

  Future<List<Squad>> getSquadsForUser(String userId) async {
    try {
      if (userId.isEmpty) {
        developer.log('Invalid user ID');
        return [];
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      final user = VolunteerUser.fromFirestore(userDoc);
      final squads = <Squad>[];

      for (final squadId in user.joinedSquads) {
        final squadDoc = await _firestore.collection('squads').doc(squadId).get();
        if (squadDoc.exists) {
          squads.add(Squad.fromFirestore(squadDoc));
        }
      }

      return squads;
    } catch (e) {
      developer.log('Get user squads error', error: e);
      return [];
    }
  }

  Future<void> updateSquadImpactHours(String squadId) async {
    try {
      if (squadId.isEmpty) {
        developer.log('Invalid squad ID');
        return;
      }

      final squadDoc = await _firestore.collection('squads').doc(squadId).get();
      if (squadDoc.exists) {
        final squad = Squad.fromFirestore(squadDoc);
        int totalHours = 0;

        for (final memberId in squad.memberIds) {
          final userDoc = await _firestore.collection('users').doc(memberId).get();
          if (userDoc.exists) {
            final user = VolunteerUser.fromFirestore(userDoc);
            totalHours += user.totalHours;
          }
        }

        await _firestore.collection('squads').doc(squadId).update({'totalImpactHours': totalHours});
      }
    } catch (e) {
      developer.log('Update squad impact hours error', error: e);
    }
  }

  // ==========================================
  // HELPER METHODS
  // ==========================================

  int _calculateLevel(int totalHours) {
    if (totalHours >= 500) return 5; // Legend
    if (totalHours >= 250) return 4; // Gold
    if (totalHours >= 100) return 3; // Silver
    if (totalHours >= 50) return 2; // Bronze
    return 1; // Starter
  }

  List<String> _calculateBadges(int totalHours, List<String> currentBadges) {
    final badges = Set<String>.from(currentBadges);

    if (totalHours >= 1) badges.add('first_step');
    if (totalHours >= 50) badges.add('committed');
    if (totalHours >= 100) badges.add('leader');
    if (totalHours >= 250) badges.add('hero');
    if (totalHours >= 500) badges.add('legend');

    return badges.toList();
  }
}
