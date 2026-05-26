import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const VolunteerHubApp());
}

// ==========================================
// ZERO-ISSUE COLOR PALETTE (Hex Alpha)
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

// ==========================================
// SIMULATED BACKEND DATA
// ==========================================
class AppData {
  static List<Map<String, dynamic>> events = [
    {
      'title': 'Tech for Good Hackathon',
      'org': 'Innovate Youth',
      'date': 'Oct 24 • Virtual',
      'description': 'Join 500+ developers to build open-source tools for local non-profits. Mentorship provided!',
      'tags': ['Coding', 'Design'],
      'icon': Icons.code,
      'slotsTotal': 50,
      'slotsFilled': 42,
    },
    {
      'title': 'Urban Farm Setup',
      'org': 'Eco Collective',
      'date': 'Oct 28 • Brooklyn, NY',
      'description': 'Help us build raised garden beds and plant winter crops for the community food bank.',
      'tags': ['Sustainability', 'Hands-on'],
      'icon': Icons.eco_outlined,
      'slotsTotal': 20,
      'slotsFilled': 20,
    },
  ];

  static List<Map<String, dynamic>> leaderboard = [
    {'name': 'Alex Rivera', 'hours': 340, 'topBadge': Icons.diamond, 'color': const Color(0xFFFFD700), 'colorBg': const Color(0x1AFFD700), 'colorBorder': const Color(0x80FFD700), 'colorShadow': const Color(0x33FFD700)}, 
    {'name': 'Wagisha (You)', 'hours': 285, 'topBadge': Icons.rocket_launch, 'color': const Color(0xFFC0C0C0), 'colorBg': const Color(0x1AC0C0C0), 'colorBorder': const Color(0x80C0C0C0), 'colorShadow': const Color(0x33C0C0C0)}, 
    {'name': 'Sam Chen', 'hours': 210, 'topBadge': Icons.star, 'color': const Color(0xFFCD7F32), 'colorBg': const Color(0x1ACD7F32), 'colorBorder': const Color(0x80CD7F32), 'colorShadow': const Color(0x33CD7F32)}, 
    {'name': 'Jordan Lee', 'hours': 150, 'topBadge': Icons.timer, 'color': Colors.transparent, 'colorBg': Colors.transparent, 'colorBorder': Colors.transparent, 'colorShadow': Colors.transparent},
    {'name': 'Casey Smith', 'hours': 95, 'topBadge': Icons.local_fire_department, 'color': Colors.transparent, 'colorBg': Colors.transparent, 'colorBorder': Colors.transparent, 'colorShadow': Colors.transparent},
  ];
}

class VolunteerHubApp extends StatelessWidget {
  const VolunteerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midnight Aurora Impact',
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
      home: const MainNavigator(),
    );
  }
}

// ==========================================
// 1. MAIN NAVIGATOR
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
// SHARED WIDGET: Neon Glowing Background
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
// 2. HOME FEED SCREEN (Events & Organizer Posting)
// ==========================================
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  
  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    int slotsTotal = event['slotsTotal'] as int;
    int slotsFilled = event['slotsFilled'] as int;
    bool isFull = slotsFilled >= slotsTotal;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(event['icon'], color: AppColors.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(child: Text(event['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
              ],
            ),
            const SizedBox(height: 16),
            Text('Organized by ${event['org']} • ${event['date']}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('About the Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(event['description'], style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFull ? null : () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFull ? Colors.grey.shade800 : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(isFull ? 'Event Full' : 'Volunteer Now', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCreateEventSheet() {
    final titleCtrl = TextEditingController();
    final orgCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final slotsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Post New Event', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 24),
              _buildTextField(titleCtrl, 'Event Title', Icons.title),
              const SizedBox(height: 16),
              _buildTextField(orgCtrl, 'Organization Name', Icons.business),
              const SizedBox(height: 16),
              _buildTextField(descCtrl, 'Description', Icons.description, maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(slotsCtrl, 'Total Volunteers Needed (e.g. 20)', Icons.group, isNumber: true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int parsedSlots = int.tryParse(slotsCtrl.text) ?? 10;
                    setState(() {
                      AppData.events.insert(0, {
                        'title': titleCtrl.text.isNotEmpty ? titleCtrl.text : 'New Event',
                        'org': orgCtrl.text.isNotEmpty ? orgCtrl.text : 'Community Member',
                        'date': 'Coming Soon',
                        'description': descCtrl.text.isNotEmpty ? descCtrl.text : 'Join us for this amazing opportunity!',
                        'tags': ['New'],
                        'icon': Icons.star,
                        'slotsTotal': parsedSlots > 0 ? parsedSlots : 10,
                        'slotsFilled': 0,
                      });
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Publish Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false, int maxLines = 1}) {
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
          label: const Text('Host Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discover', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  CircleAvatar(backgroundColor: AppColors.surface, child: Icon(Icons.filter_list, color: AppColors.secondary)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: AppData.events.length,
                itemBuilder: (context, index) {
                  final event = AppData.events[index];
                  int slotsTotal = event['slotsTotal'] as int;
                  int slotsFilled = event['slotsFilled'] as int;
                  double fillPercentage = slotsTotal > 0 ? slotsFilled / slotsTotal : 0.0;
                  bool isFull = fillPercentage >= 1.0;

                  return GestureDetector(
                    onTap: () => _showEventDetails(context, event),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface80,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white10, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: AppColors.primary20, borderRadius: BorderRadius.circular(16)),
                                  child: Icon(event['icon'] as IconData, color: AppColors.primary),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(event['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      Text('${event['org']} • ${event['date']}', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$slotsFilled/$slotsTotal Slots Filled', style: TextStyle(color: isFull ? Colors.redAccent : Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                                if (isFull) const Text('FULL', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: fillPercentage,
                                backgroundColor: Colors.white10,
                                color: isFull ? Colors.redAccent : AppColors.secondary,
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: (event['tags'] as List<String>).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: AppColors.secondary15, borderRadius: BorderRadius.circular(8)),
                                  child: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
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
// 3. LEADERBOARD SCREEN
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
            child: Text('Global Ranks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: AppData.leaderboard.length,
              itemBuilder: (context, index) {
                final user = AppData.leaderboard[index];
                bool isTop3 = index < 3;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isTop3 ? user['colorBg'] : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isTop3 ? user['colorBorder'] : Colors.white10, width: isTop3 ? 2 : 1),
                    boxShadow: isTop3 ? [BoxShadow(color: user['colorShadow'], blurRadius: 15)] : [],
                  ),
                  child: Row(
                    children: [
                      Text('#${index + 1}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isTop3 ? user['color'] : Colors.grey.shade500)),
                      const SizedBox(width: 16),
                      CircleAvatar(backgroundColor: Colors.white10, child: Icon(user['topBadge'], color: isTop3 ? user['color'] : Colors.white)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: user['name'].contains('You') ? AppColors.secondary : Colors.white)),
                            Text('${user['hours']} Impact Hours', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
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
// 4. IMPACT DASHBOARD
// ==========================================
class ImpactDashboardScreen extends StatelessWidget {
  const ImpactDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Impact', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
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
                    border: Border.all(color: Colors.white12, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Text('Total Hours', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      const Text('285', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(value: 0.85, backgroundColor: Colors.white10, color: AppColors.primary, minHeight: 12),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Silver Tier (250h)', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                          Text('Gold Tier (300h)', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Only 15 hours away from Gold Tier!', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Milestone Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildBadge(context, 'First Step', '1 Hour', Icons.pets, true),
                _buildBadge(context, 'Committed', '50 Hours', Icons.timer, true),
                _buildBadge(context, 'Leader', '100 Hours', Icons.star, true),
                _buildBadge(context, 'Hero', '250 Hours', Icons.rocket_launch, true),
                _buildBadge(context, 'Legend', '500 Hours', Icons.diamond, false),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String title, String requirement, IconData icon, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primary10 : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: unlocked ? AppColors.primary50 : Colors.white10, width: unlocked ? 2 : 1),
            boxShadow: unlocked ? [const BoxShadow(color: AppColors.primary20, blurRadius: 15)] : [],
          ),
          child: Icon(icon, color: unlocked ? AppColors.primary : Colors.grey.shade700, size: 32),
        ),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: unlocked ? Colors.white : Colors.grey.shade600)),
        Text(requirement, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}

// ==========================================
// 5. SQUADS SCREEN
// ==========================================
class SquadsScreen extends StatelessWidget {
  const SquadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: Center(
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
                  border: Border.all(color: AppColors.secondary30, width: 2),
                  boxShadow: const [BoxShadow(color: AppColors.secondary20, blurRadius: 30)],
                ),
                child: const Icon(Icons.hub_outlined, size: 64, color: AppColors.secondary),
              ),
              const SizedBox(height: 32),
              const Text('Build Your Network', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text(
                'Invite peers to form a squad. Track collective impact and unlock community grants.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invite link copied to clipboard!', style: TextStyle(color: Colors.black)),
                        backgroundColor: AppColors.secondary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary, 
                    foregroundColor: Colors.black, 
                    elevation: 10,
                    shadowColor: AppColors.secondary50,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Copy Invite Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. PROFILE SCREEN
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernBackground(
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.primary, width: 3), 
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/300'), 
                  fit: BoxFit.cover,
                ),
                boxShadow: const [BoxShadow(color: AppColors.primary30, blurRadius: 20)],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Wagisha', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
          Center(child: Text('wagisha@modernimpact.org', style: TextStyle(color: Colors.grey.shade400, fontSize: 14))),
          const SizedBox(height: 40),
          
          const Text('Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 16),
          
          _buildCleanMenuOption(context, Icons.person_outline, 'Personal Info'),
          _buildCleanMenuOption(context, Icons.shield_outlined, 'Privacy & Safety'),
          _buildCleanMenuOption(context, Icons.notifications_none, 'Notifications'),
          
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF4D4D)),
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildCleanMenuOption(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
        onTap: () {},
      ),
    );
  }
}