import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Jadwal kuliah Mobile pindah ke Ruang A2 jam 13.00.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
