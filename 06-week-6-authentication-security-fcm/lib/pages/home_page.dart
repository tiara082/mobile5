import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman Kampus'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: const Text('Jadwal kuliah berubah'),
              subtitle: const Text('Kelas Mobile pindah ke Ruang A2 jam 13.00'),
              onTap: () => context.go(AppRoutes.announcementFor('3')),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.security),
              title: Text('Sesi dan notifikasi aman'),
              subtitle: Text('Token disimpan di secure storage; topik FCM aktif.'),
            ),
          ),
        ],
      ),
    );
  }
}
