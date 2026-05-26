import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'models/models.dart';
import 'providers/app_provider.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.initialize();
  runApp(
    ChangeNotifierProvider.value(
      value: appProvider,
      child: const VolunteerSquadApp(),
    ),
  );
}

// ==========================================
// COLOR PALETTE
// ==========================================
class AppColors {
  static const Color bg = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF161D2F);
  static const Color surface80 = Color(0xCC161D2F);
  static const Color primary = Color(0xFF9D4EDD);
  static const Color primary10 = Color(0x1A9D4EDD);
  static const Color primary15 = Color(0x269D4EDD);
  static const Color primary20 = Color(0x339D4EDD);
  static const Color primary30 = Color(0x4D9D4EDD);
  static const Color primary50 = Color(0x809D4EDD);
  static const Color secondary = Color(0xFF00F5D4);
  static const Color secondary10 = Color(0x1A00F5D4);
  static const Color secondary15 = Color(0x2600F5D4);
  static const Color secondary20 = Color(0x3300F5D4);
  static const Color secondary30 = Color(0x4D00F5D4);
  static const Color secondary50 = Color(0x8000F5D4);
}

class VolunteerSquadApp extends StatelessWidget {
  const VolunteerSquadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Squad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5, color: Colors.white),
          bodyLarge: TextStyle(letterSpacing: 0.2, color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white10, width: 1),
          ),
        ),
      ),
      home: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          if (appProvider.currentUser == null) {
            return const AuthScreen();
          }
          return const MainNavigator();
        },
      ),
    );
  }
}

// ==========================================
// MODERN BACKGROUND
// ==========================================
class ModernBackground extends StatelessWidget {
  final Widget child;
  const ModernBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary15,
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary10,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(color: Colors.transparent),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

// ==========================================
// AUTH SCREEN
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  bool _isLoading = false;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _userType = 'volunteer';
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    _errorMessage = null;

    // Validate email
    if (_emailCtrl.text.isEmpty) {
      _errorMessage = 'Email is required';
      return false;
    }
    if (!_isValidEmail(_emailCtrl.text)) {
      _errorMessage = 'Please enter a valid email';
      return false;
    }

    // Validate password
    if (_passwordCtrl.text.isEmpty) {
      _errorMessage = 'Password is required';
      return false;
    }
    if (_isSignUp && !_isStrongPassword(_passwordCtrl.text)) {
      _errorMessage = 'Password must be at least 8 characters with uppercase, lowercase, and numbers';
      return false;
    }
    if (!_isSignUp && _passwordCtrl.text.length < 6) {
      _errorMessage = 'Invalid password';
      return false;
    }

    // Validate name for signup
    if (_isSignUp) {
      if (_nameCtrl.text.isEmpty) {
        _errorMessage = 'Name is required';
        return false;
      }
      if (_nameCtrl.text.length > 100) {
        _errorMessage = 'Name is too long';
        return false;
      }
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.volunteer_activism, size: 64, color: AppColors.secondary),
              const SizedBox(height: 24),
              const Text('Volunteer Squad', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Make an Impact Together', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 60),
              
              // Error message display
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade400, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade400, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade400, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 16),
              
              if (_isSignUp) ...[
                _buildTextField(_nameCtrl, 'Full Name', Icons.person, enabled: !_isLoading),
                const SizedBox(height: 16),
              ],
              _buildTextField(_emailCtrl, 'Email', Icons.email, enabled: !_isLoading),
              const SizedBox(height: 16),
              _buildTextField(_passwordCtrl, 'Password', Icons.lock, isPassword: true, enabled: !_isLoading),
              
              if (_isSignUp) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: DropdownButton<String>(
                    value: _userType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: AppColors.surface,
                    items: const [
                      DropdownMenuItem(value: 'volunteer', child: Text('Volunteer')),
                      DropdownMenuItem(value: 'organization', child: Text('Organization')),
                    ],
                    onChanged: _isLoading ? null : (value) => setState(() => _userType = value ?? 'volunteer'),
                  ),
                ),
              ],
              
              if (_isSignUp && _isSignUp)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Password must contain: 8+ characters, uppercase, lowercase, and numbers',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, _) {
                    return ElevatedButton(
                      onPressed: (_isLoading || appProvider.isLoading)
                          ? null
                          : () async {
                              if (!_validateInputs()) {
                                setState(() {});
                                return;
                              }

                              setState(() => _isLoading = true);

                              if (_isSignUp) {
                                final success = await appProvider.signUp(
                                  _emailCtrl.text,
                                  _passwordCtrl.text,
                                  _nameCtrl.text,
                                  _userType,
                                );
                                if (!success && mounted) {
                                  setState(() => _errorMessage = appProvider.error ?? 'Sign up failed');
                                }
                              } else {
                                final success = await appProvider.signIn(
                                  _emailCtrl.text,
                                  _passwordCtrl.text,
                                );
                                if (!success && mounted) {
                                  setState(() => _errorMessage = appProvider.error ?? 'Sign in failed');
                                }
                              }

                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                      child: Text(
                        _isLoading || appProvider.isLoading ? 'Loading...' : (_isSignUp ? 'Create Account' : 'Sign In'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isSignUp ? 'Already have an account? ' : 'Don\'t have an account? ',
                      style: const TextStyle(color: Colors.white70)),
                  GestureDetector(
                    onTap: _isLoading ? null : () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                        _errorMessage = null;
                        _emailCtrl.clear();
                        _passwordCtrl.clear();
                        _nameCtrl.clear();
                      });
                    },
                    child: Text(_isSignUp ? 'Sign In' : 'Sign Up',
                        style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, 
      {bool isPassword = false, bool enabled = true}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

// ==========================================
// MAIN NAVIGATOR
// ==========================================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeFeedScreen(),
    LeaderboardScreen(),
    ImpactDashboardScreen(),
    SquadsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.loadAllEvents();
      appProvider.loadLeaderboard();
      appProvider.loadMatchedEvents();
      appProvider.loadUserSquads();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.bg,
          elevation: 0,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey.shade600,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: 'Ranks'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined), activeIcon: Icon(Icons.auto_graph), label: 'Impact'),
            BottomNavigationBarItem(icon: Icon(Icons.diversity_3_outlined), activeIcon: Icon(Icons.diversity_3), label: 'Squads'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HOME FEED SCREEN
// ==========================================
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  void _showEventDetails(BuildContext context, VolunteerEvent event) {
    bool isFull = event.filledSlots >= event.totalSlots;
    bool isRegistered = event.registeredVolunteers.contains(
        Provider.of<AppProvider>(context, listen: false).currentUser?.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text(event.title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            Text('${event.organizationName} • ${event.location}',
                style: const TextStyle(
                    color: AppColors.secondary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('About the Event',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(event.description,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            Text('Required Skills: ${event.requiredSkills.join(", ")}',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            Text('Estimated Hours: ${event.estimatedHours}h',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFull
                    ? null
                    : () {
                        if (isRegistered) {
                          Provider.of<AppProvider>(context, listen: false)
                              .unregisterFromEvent(event.id);
                        } else {
                          Provider.of<AppProvider>(context, listen: false)
                              .registerForEvent(event.id);
                        }
                        Navigator.pop(ctx);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRegistered
                      ? Colors.red
                      : (isFull ? Colors.grey.shade800 : AppColors.primary),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  isFull
                      ? 'Event Full'
                      : (isRegistered ? 'Cancel Registration' : 'Volunteer Now'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCreateEventSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final slotsCtrl = TextEditingController();
    final hoursCtrl = TextEditingController();
    List<String> selectedSkills = [];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Post New Event',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 24),
              _buildTextField(titleCtrl, 'Event Title', Icons.title),
              const SizedBox(height: 16),
              _buildTextField(descCtrl, 'Description', Icons.description,
                  maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(locationCtrl, 'Location', Icons.location_on),
              const SizedBox(height: 16),
              _buildTextField(slotsCtrl, 'Total Volunteers Needed',
                  Icons.group,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(hoursCtrl, 'Estimated Hours', Icons.timer,
                  isNumber: true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AppProvider>(context, listen: false)
                        .createEvent(
                      titleCtrl.text.isNotEmpty
                          ? titleCtrl.text
                          : 'New Event',
                      descCtrl.text.isNotEmpty
                          ? descCtrl.text
                          : 'Join us for this amazing opportunity!',
                      selectedSkills,
                      DateTime.now().add(const Duration(days: 7)),
                      locationCtrl.text.isNotEmpty
                          ? locationCtrl.text
                          : 'TBD',
                      int.tryParse(slotsCtrl.text) ?? 10,
                      'Community Service',
                      int.tryParse(hoursCtrl.text) ?? 4,
                    );
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Publish Event',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateEventSheet,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Host Event',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discover Events',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  CircleAvatar(
                      backgroundColor: AppColors.surface,
                      child: Icon(Icons.filter_list,
                          color: AppColors.secondary)),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, appProvider, _) {
                  if (appProvider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.secondary));
                  }

                  final events = appProvider.currentUser?.userType == 'organization'
                      ? appProvider.allEvents
                      : appProvider.matchedEvents.isNotEmpty
                          ? appProvider.matchedEvents
                          : appProvider.allEvents;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      double fillPercentage = event.totalSlots > 0
                          ? event.filledSlots / event.totalSlots
                          : 0.0;
                      bool isFull = fillPercentage >= 1.0;

                      return GestureDetector(
                        onTap: () => _showEventDetails(context, event),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.surface80,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white10, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(event.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(
                                    '${event.organizationName} • ${event.location}',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13)),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${event.filledSlots}/${event.totalSlots} Slots',
                                        style: TextStyle(
                                            color: isFull
                                                ? Colors.redAccent
                                                : Colors.grey.shade400,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    if (isFull)
                                      const Text('FULL',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: fillPercentage,
                                    backgroundColor: Colors.white10,
                                    color: isFull
                                        ? Colors.redAccent
                                        : AppColors.secondary,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// LEADERBOARD SCREEN
// ==========================================
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text('Global Ranks',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, appProvider, _) {
                if (appProvider.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.secondary));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: appProvider.leaderboard.length,
                  itemBuilder: (context, index) {
                    final user = appProvider.leaderboard[index];
                    bool isTop3 = index < 3;
                    bool isCurrentUser =
                        user.id == appProvider.currentUser?.id;

                    Color medalColor = Colors.transparent;
                    if (index == 0) medalColor = const Color(0xFFFFD700);
                    if (index == 1) medalColor = const Color(0xFFC0C0C0);
                    if (index == 2) medalColor = const Color(0xFFCD7F32);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isTop3
                            ? medalColor.withOpacity(0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isTop3
                                ? medalColor.withOpacity(0.5)
                                : Colors.white10,
                            width: isTop3 ? 2 : 1),
                        boxShadow: isTop3
                            ? [
                                BoxShadow(
                                    color: medalColor.withOpacity(0.2),
                                    blurRadius: 15)
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Text('#${index + 1}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isTop3
                                      ? medalColor
                                      : Colors.grey.shade500)),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(
                              index == 0
                                  ? Icons.diamond
                                  : (index == 1
                                      ? Icons.rocket_launch
                                      : Icons.star),
                              color: isTop3 ? medalColor : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrentUser
                                      ? '${user.name} (You)'
                                      : user.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrentUser
                                          ? AppColors.secondary
                                          : Colors.white),
                                ),
                                Text('${user.totalHours} Impact Hours',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// IMPACT DASHBOARD SCREEN
// ==========================================
class ImpactDashboardScreen extends StatelessWidget {
  const ImpactDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<AppProvider>(
          builder: (context, appProvider, _) {
            final user = appProvider.currentUser;
            if (user == null) {
              return const Center(child: Text('Loading...'));
            }

            int nextTierHours = 0;
            String nextTierName = '';
            if (user.totalHours < 50) {
              nextTierHours = 50;
              nextTierName = 'Bronze (50h)';
            } else if (user.totalHours < 100) {
              nextTierHours = 100;
              nextTierName = 'Silver (100h)';
            } else if (user.totalHours < 250) {
              nextTierHours = 250;
              nextTierName = 'Gold (250h)';
            } else if (user.totalHours < 500) {
              nextTierHours = 500;
              nextTierName = 'Legend (500h)';
            }

            double progressToNext = nextTierHours > 0
                ? (user.totalHours / nextTierHours).clamp(0.0, 1.0)
                : 1.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Impact',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: Colors.white12, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Text('Total Hours',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text('${user.totalHours}',
                              style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary)),
                          const SizedBox(height: 24),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressToNext,
                              backgroundColor: Colors.white10,
                              color: AppColors.primary,
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Current Level',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold)),
                              Text(nextTierName,
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                              'Only ${nextTierHours - user.totalHours} hours away!',
                              style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Milestone Badges',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildBadge(context, 'First Step', '1 Hour',
                        Icons.pets, user.unlockedBadges.contains('first_step')),
                    _buildBadge(context, 'Committed', '50 Hours',
                        Icons.timer, user.unlockedBadges.contains('committed')),
                    _buildBadge(context, 'Leader', '100 Hours',
                        Icons.star, user.unlockedBadges.contains('leader')),
                    _buildBadge(context, 'Hero', '250 Hours',
                        Icons.rocket_launch, user.unlockedBadges.contains('hero')),
                    _buildBadge(context, 'Legend', '500 Hours',
                        Icons.diamond, user.unlockedBadges.contains('legend')),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String title, String requirement,
      IconData icon, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primary10 : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: unlocked ? AppColors.primary50 : Colors.white10,
                width: unlocked ? 2 : 1),
            boxShadow: unlocked
                ? [const BoxShadow(color: AppColors.primary20, blurRadius: 15)]
                : [],
          ),
          child: Icon(icon,
              color: unlocked ? AppColors.primary : Colors.grey.shade700,
              size: 32),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: unlocked ? Colors.white : Colors.grey.shade600)),
        Text(requirement,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}

// ==========================================
// SQUADS SCREEN
// ==========================================
class SquadsScreen extends StatefulWidget {
  const SquadsScreen({super.key});

  @override
  State<SquadsScreen> createState() => _SquadsScreenState();
}

class _SquadsScreenState extends State<SquadsScreen> {
  void _showCreateSquadSheet() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create a Squad',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Squad Name',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Squad Description',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AppProvider>(context, listen: false)
                        .createSquad(nameCtrl.text, descCtrl.text);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Create Squad',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinSquadSheet() {
    final codeCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Join a Squad',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: codeCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter Invite Code',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AppProvider>(context, listen: false)
                        .joinSquadByCode(codeCtrl.text);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Join Squad',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text('Your Squads',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, appProvider, _) {
                  if (appProvider.userSquads.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface,
                                border: Border.all(
                                    color: AppColors.secondary30, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.secondary20,
                                      blurRadius: 30)
                                ],
                              ),
                              child: const Icon(Icons.hub_outlined,
                                  size: 64, color: AppColors.secondary),
                            ),
                            const SizedBox(height: 32),
                            const Text('Build Your Network',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 16),
                            const Text(
                              'Create or join a squad to coordinate with peers and track collective impact.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.5),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _showCreateSquadSheet,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Create'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _showJoinSquadSheet,
                                  icon: const Icon(Icons.login),
                                  label: const Text('Join'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: appProvider.userSquads.length,
                    itemBuilder: (context, index) {
                      final squad = appProvider.userSquads[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface80,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white10, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(squad.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(squad.description,
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${squad.memberIds.length} Members',
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '${squad.totalImpactHours} Total Hours',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.secondary10,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Code: ${squad.inviteCode}',
                                style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateSquadSheet,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New Squad',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ==========================================
// PROFILE SCREEN
// ==========================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showSkillsSheet() {
    final allSkills = [
      'Coding',
      'Design',
      'Teaching',
      'Mentoring',
      'Writing',
      'Marketing',
      'Data Analysis',
      'Project Management',
      'Sustainability',
      'Healthcare',
      'Community Outreach',
      'Event Planning'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Your Skills',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allSkills.map((skill) {
                final isSelected =
                    Provider.of<AppProvider>(context, listen: false)
                        .currentUser
                        ?.skills
                        .contains(skill) ??
                    false;
                return GestureDetector(
                  onTap: () {
                    final currentSkills =
                        Provider.of<AppProvider>(context, listen: false)
                            .currentUser
                            ?.skills ??
                        [];
                    final updatedSkills = isSelected
                        ? currentSkills
                            .where((s) => s != skill)
                            .toList()
                        : [...currentSkills, skill];
                    Provider.of<AppProvider>(context, listen: false)
                        .updateUserSkills(updatedSkills);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(skill,
                        style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Done',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<AppProvider>(
          builder: (context, appProvider, _) {
            final user = appProvider.currentUser;
            if (user == null) {
              return const Center(child: Text('Loading...'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.surface,
                          child: Icon(
                            user.userType == 'organization'
                                ? Icons.business
                                : Icons.person,
                            size: 50,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(user.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(user.email,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary20,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.userType == 'organization'
                                ? 'Organization'
                                : 'Volunteer',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('Stats',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface80,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white10, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text('${user.totalHours}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary)),
                              const SizedBox(height: 4),
                              Text('Impact Hours',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface80,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white10, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text('${user.level}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text('Level',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (user.userType == 'volunteer') ...[
                    const Text('Skills',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 16),
                    if (user.skills.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface80,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white10, width: 1),
                        ),
                        child: Center(
                          child: Text('No skills added yet',
                              style: TextStyle(
                                  color: Colors.grey.shade400)),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary15,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(skill,
                                style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showSkillsSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Update Skills',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        appProvider.signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Sign Out',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
