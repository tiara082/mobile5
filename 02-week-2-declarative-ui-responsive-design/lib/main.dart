import 'package:flutter/material.dart';

// Single breakpoint constant defined once as required by the assignment
const double kWideBreakpoint = 700.0;

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryAccent = Color(0xFF4F46E5); // Minimalist Indigo Line Accent

    return MaterialApp(
      title: 'Academic Dashboard - Week 2',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Minimalist Light Theme using Theme.of(context) tokens
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryAccent,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: primaryAccent, width: 1.2),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        useMaterial3: true,
      ),
      // Minimalist Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF818CF8),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF6366F1), width: 1.2),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF8FAFC),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2E8F0),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
        useMaterial3: true,
      ),
      home: DashboardHomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const DashboardHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Dashboard'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE0E7FF),
            height: 1.0,
          ),
        ),
        actions: [
          Semantics(
            label: 'Toggle light and dark theme mode',
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  size: 20,
                  color: theme.textTheme.titleMedium?.color,
                ),
                const SizedBox(width: 4),
                Switch.adaptive(
                  value: isDarkMode,
                  onChanged: onThemeChanged,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= kWideBreakpoint;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Profile Header Card
                Semantics(
                  label: 'Student Profile Summary Card for Tiara Febrianie',
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: theme.cardTheme.color,
                              child: Text(
                                'T',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tiara Febrianie',
                                  style: theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'NIM: 244107020097',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Class: TI-3I | D4 Teknik Informatika',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Section Title
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Academic Overview',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Responsive Academic Overview Cards Layout
                if (isWide)
                  _buildWideLayout(context)
                else
                  _buildNarrowLayout(context),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // 1-column layout for narrow screens (< kWideBreakpoint)
  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildGpaCard(),
        const SizedBox(height: 12),
        _buildSksCard(),
        const SizedBox(height: 12),
        _buildAttendanceCard(),
        const SizedBox(height: 12),
        _buildSemesterCard(),
      ],
    );
  }

  // 2-column layout for wide screens (>= kWideBreakpoint)
  Widget _buildWideLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildGpaCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildSksCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildAttendanceCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildSemesterCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildGpaCard() {
    return const InfoCard(
      title: 'Cumulative GPA (IPK)',
      value: '3.85 / 4.00',
      icon: Icons.grade_outlined,
      semanticsLabel: 'Cumulative GPA: 3.85 out of 4.00',
    );
  }

  Widget _buildSksCard() {
    return const InfoCard(
      title: 'Enrolled Credits (SKS)',
      value: '22 SKS',
      icon: Icons.auto_stories_outlined,
      semanticsLabel: 'Enrolled Credits: 22 SKS',
    );
  }

  Widget _buildAttendanceCard() {
    return const InfoCard(
      title: 'Attendance Rate',
      value: '98.5%',
      icon: Icons.event_available_outlined,
      semanticsLabel: 'Attendance Rate: 98.5 percent',
    );
  }

  Widget _buildSemesterCard() {
    return const InfoCard(
      title: 'Active Semester',
      value: 'Semester 4 (Active)',
      icon: Icons.calendar_month_outlined,
      semanticsLabel: 'Active Semester: Semester 4 Active',
    );
  }
}

/// Reusable InfoCard Widget refactored as required by the assignment
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String semanticsLabel;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticsLabel,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
