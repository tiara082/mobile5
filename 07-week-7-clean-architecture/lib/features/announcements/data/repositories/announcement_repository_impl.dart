import '../../../../core/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({List<Map<String, Object?>>? seed})
      : _rows = seed ??
            [
              {
                'id': '3',
                'title': 'Jadwal kuliah berubah',
                'body': 'Kelas Mobile pindah ke Ruang A2 jam 13.00.',
                'updated_at': DateTime(2026, 9, 27).toIso8601String(),
              },
            ];

  final List<Map<String, Object?>> _rows;

  @override
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements() async {
    try {
      final items = _rows
          .map(AnnouncementModel.fromMap)
          .map((model) => model.toEntity())
          .toList(growable: false);
      return (announcements: items, failure: null);
    } on Object catch (error) {
      return (
        announcements: const <Announcement>[],
        failure: LocalFailure('Gagal membaca pengumuman: $error'),
      );
    }
  }

  @override
  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  ) async {
    final row = _rows.where((item) => item['id'] == id).firstOrNull;
    if (row == null) {
      return (
        announcement: null,
        failure: const LocalFailure('Pengumuman tidak ditemukan.'),
      );
    }
    return (
      announcement: AnnouncementModel.fromMap(row).toEntity(),
      failure: null,
    );
  }
}
