import 'package:flutter/material.dart';

void main() {
  runApp(const StudentProfileApp());
}

class StudentProfileApp extends StatefulWidget {
  const StudentProfileApp({super.key});

  @override
  State<StudentProfileApp> createState() => _StudentProfileAppState();
}

class _StudentProfileAppState extends State<StudentProfileApp> {
  // Theme state
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile - Week 1',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Premium Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF4B5563),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        useMaterial3: true,
      ),
      // Premium Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF8FAFC),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFFCBD5E1),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
        useMaterial3: true,
      ),
      home: ProfileHomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class ProfileHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ProfileHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  // Student Profile details (Stateful to allow editing & demonstrate declarative UI)
  String _name = "Muhammad Daffa";
  String _studentId = "244107020097";
  String _major = "Teknologi Informasi";
  String _class = "TI-2H";
  String _email = "daffa.student@example.com";
  String _hobby = "Mobile App Development";

  // State to demonstrate Hot Reload vs Hot Restart
  int _stateDemoCounter = 0;

  void _incrementDemoCounter() {
    setState(() {
      _stateDemoCounter++;
    });
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _name);
    final idController = TextEditingController(text: _studentId);
    final majorController = TextEditingController(text: _major);
    final classController = TextEditingController(text: _class);
    final emailController = TextEditingController(text: _email);
    final hobbyController = TextEditingController(text: _hobby);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Student ID (NIM)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: majorController,
                  decoration: const InputDecoration(labelText: 'Major'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: classController,
                  decoration: const InputDecoration(labelText: 'Class'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: hobbyController,
                  decoration: const InputDecoration(labelText: 'Hobby/Interest'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                  _studentId = idController.text;
                  _major = majorController.text;
                  _class = classController.text;
                  _email = emailController.text;
                  _hobby = hobbyController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.isDarkMode ? const Color(0xFF64FFDA) : Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Portfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.amber : Colors.indigo,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Dark/Light Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar with animated border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [primaryColor, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: primaryColor.withValues(alpha: 0.15),
                            child: Text(
                              _name.isNotEmpty ? _name[0].toUpperCase() : 'S',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Student Name
                      Text(
                        _name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      // Student ID Label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NIM: $_studentId',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick info icons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildHeaderBadge(context, Icons.school, _major),
                          _buildHeaderBadge(context, Icons.class_, _class),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _showEditDialog,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Student Details'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Extra Information Section (Assignment Requirement)
              Text(
                'Student Information Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      _buildDetailRow(context, Icons.badge_outlined, 'NIM', _studentId),
                      const Divider(height: 1, indent: 56),
                      _buildDetailRow(context, Icons.school_outlined, 'Major', _major),
                      const Divider(height: 1, indent: 56),
                      _buildDetailRow(context, Icons.group_outlined, 'Class', _class),
                      const Divider(height: 1, indent: 56),
                      _buildDetailRow(context, Icons.email_outlined, 'Email', _email),
                      const Divider(height: 1, indent: 56),
                      _buildDetailRow(context, Icons.favorite_border_outlined, 'Specialization', _hobby),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Hot Reload vs Hot Restart Interactive Demo
              Text(
                'Interactive Flutter State Demo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hot Reload vs Hot Restart Visualizer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. Tap the button below to increment the demo state counter.\n'
                        '2. Perform a "Hot Reload" in your IDE. Notice that the counter value is maintained!\n'
                        '3. Perform a "Hot Restart". Notice that the counter resets back to 0.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('State Counter Value:'),
                              Text(
                                '$_stateDemoCounter',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _incrementDemoCounter,
                            icon: const Icon(Icons.add),
                            label: const Text('Increment State'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor.withValues(alpha: 0.2),
                              foregroundColor: primaryColor,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Lab Reflections (Academic requirement)
              Text(
                'Academic Lab Reflections',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildReflectionCard(
                context,
                'Hot Reload vs Hot Restart',
                '• Hot Reload: Loads code changes into the VM and rebuilds the widget tree, keeping the current State. Perfect for UI tweaks (takes ~1s).\n'
                '• Hot Restart: Reloads code changes and restarts the app, wiping out the State and rebuilding the widget tree from scratch. Required for structural/state initialization changes.',
                Icons.bolt,
              ),
              const SizedBox(height: 8),
              _buildReflectionCard(
                context,
                'Declarative UI & State Change',
                'In declarative UI (Flutter), the UI is a function of state: UI = f(State). '
                'When you trigger setState() (like modifying details or incrementing the counter), Flutter rebuilds the corresponding sub-tree. '
                'Instead of manually updating elements, we update state, and Flutter efficiently redraws the updated widgets.',
                Icons.account_tree_outlined,
              ),
              const SizedBox(height: 8),
              _buildReflectionCard(
                context,
                'Native vs Cross-Platform',
                '• Native (Swift/Kotlin): Best for heavy platform integrations, high-performance gaming, background tasks, hardware-specific capabilities, or OS-native UI.\n'
                '• Cross-Platform (Flutter): Best for rapid prototyping, identical UI across platforms, cost-effective MVP development, and most standard data/content-driven apps.',
                Icons.phone_android_outlined,
              ),
              const SizedBox(height: 8),
              _buildReflectionCard(
                context,
                'Why Small Commits Matter',
                'Small, meaningful commits with clear messages allow team members to track progress easily, perform code reviews smoothly, locate bugs (via git bisect), and present a polished Git portfolio that shows clear problem-solving evolution.',
                Icons.commit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
