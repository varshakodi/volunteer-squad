import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  VolunteerUser? _currentUser;
  List<VolunteerEvent> _allEvents = [];
  List<VolunteerEvent> _matchedEvents = [];
  List<VolunteerUser> _leaderboard = [];
  List<Squad> _userSquads = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  VolunteerUser? get currentUser => _currentUser;
  List<VolunteerEvent> get allEvents => _allEvents;
  List<VolunteerEvent> get matchedEvents => _matchedEvents;
  List<VolunteerUser> get leaderboard => _leaderboard;
  List<Squad> get userSquads => _userSquads;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==========================================
  // INITIALIZATION
  // ==========================================

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.initializeFirebase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Initialization error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // AUTHENTICATION
  // ==========================================

  Future<bool> signUp(String email, String password, String name, String userType) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseService.signUpWithEmail(email, password, name, userType);
      if (result != null) {
        await loadCurrentUser(result.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'Sign up failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Sign up error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseService.signInWithEmail(email, password);
      if (result != null) {
        await loadCurrentUser(result.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'Sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Sign in error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    _currentUser = null;
    _allEvents = [];
    _matchedEvents = [];
    _leaderboard = [];
    _userSquads = [];
    notifyListeners();
  }

  // ==========================================
  // USER MANAGEMENT
  // ==========================================

  Future<void> loadCurrentUser(String userId) async {
    try {
      _currentUser = await _firebaseService.getUserById(userId);
      notifyListeners();
    } catch (e) {
      _error = 'Load user error: $e';
      notifyListeners();
    }
  }

  Future<void> updateUserSkills(List<String> skills) async {
    if (_currentUser == null) return;

    try {
      await _firebaseService.updateUserSkills(_currentUser!.id, skills);
      _currentUser = _currentUser!.copyWith(skills: skills);
      notifyListeners();
    } catch (e) {
      _error = 'Update skills error: $e';
      notifyListeners();
    }
  }

  // ==========================================
  // EVENTS
  // ==========================================

  Future<void> loadAllEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allEvents = await _firebaseService.getAllEvents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Load events error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMatchedEvents() async {
    if (_currentUser == null) return;

    try {
      _matchedEvents = await _firebaseService.getMatchedEventsForVolunteer(_currentUser!.id);
      notifyListeners();
    } catch (e) {
      _error = 'Load matched events error: $e';
      notifyListeners();
    }
  }

  Future<bool> createEvent(String title, String description, List<String> requiredSkills, 
      DateTime eventDate, String location, int totalSlots, String category, int estimatedHours) async {
    if (_currentUser == null) return false;

    try {
      final event = VolunteerEvent(
        id: '',
        title: title,
        organizationId: _currentUser!.id,
        organizationName: _currentUser!.name,
        description: description,
        requiredSkills: requiredSkills,
        eventDate: eventDate,
        location: location,
        totalSlots: totalSlots,
        filledSlots: 0,
        registeredVolunteers: [],
        category: category,
        estimatedHours: estimatedHours,
        createdAt: DateTime.now(),
      );

      final eventId = await _firebaseService.createEvent(event);
      if (eventId.isNotEmpty) {
        await loadAllEvents();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Create event error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> registerForEvent(String eventId) async {
    if (_currentUser == null) return;

    try {
      await _firebaseService.registerVolunteerForEvent(eventId, _currentUser!.id);
      await loadAllEvents();
      await loadMatchedEvents();
      notifyListeners();
    } catch (e) {
      _error = 'Register error: $e';
      notifyListeners();
    }
  }

  Future<void> unregisterFromEvent(String eventId) async {
    if (_currentUser == null) return;

    try {
      await _firebaseService.unregisterVolunteerFromEvent(eventId, _currentUser!.id);
      await loadAllEvents();
      await loadMatchedEvents();
      notifyListeners();
    } catch (e) {
      _error = 'Unregister error: $e';
      notifyListeners();
    }
  }

  // ==========================================
  // IMPACT TRACKING
  // ==========================================

  Future<void> logImpactHours(String eventId, int hours, String notes) async {
    if (_currentUser == null) return;

    try {
      await _firebaseService.logImpactHours(_currentUser!.id, eventId, hours, notes);
      await loadCurrentUser(_currentUser!.id);
      await loadLeaderboard();
      notifyListeners();
    } catch (e) {
      _error = 'Log hours error: $e';
      notifyListeners();
    }
  }

  // ==========================================
  // LEADERBOARD
  // ==========================================

  Future<void> loadLeaderboard() async {
    try {
      _leaderboard = await _firebaseService.getGlobalLeaderboard();
      notifyListeners();
    } catch (e) {
      _error = 'Load leaderboard error: $e';
      notifyListeners();
    }
  }

  // ==========================================
  // SQUADS
  // ==========================================

  Future<bool> createSquad(String name, String description) async {
    if (_currentUser == null) return false;

    try {
      final squadId = await _firebaseService.createSquad(name, description, _currentUser!.id);
      if (squadId.isNotEmpty) {
        await loadUserSquads();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Create squad error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinSquadByCode(String inviteCode) async {
    if (_currentUser == null) return false;

    try {
      final squad = await _firebaseService.getSquadByInviteCode(inviteCode);
      if (squad != null) {
        await _firebaseService.joinSquad(squad.id, _currentUser!.id);
        await loadUserSquads();
        return true;
      }
      _error = 'Squad not found';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Join squad error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserSquads() async {
    if (_currentUser == null) return;

    try {
      _userSquads = await _firebaseService.getSquadsForUser(_currentUser!.id);
      notifyListeners();
    } catch (e) {
      _error = 'Load squads error: $e';
      notifyListeners();
    }
  }
}


