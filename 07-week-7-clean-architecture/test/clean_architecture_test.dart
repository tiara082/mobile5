import 'package:flutter_test/flutter_test.dart';

import 'package:campus_notify_clean/core/failures.dart';
import 'package:campus_notify_clean/core/format.dart';
import 'package:campus_notify_clean/features/announcements/domain/entities/announcement.dart';
import 'package:campus_notify_clean/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:campus_notify_clean/features/announcements/domain/usecases/get_announcement.dart';
import 'package:campus_notify_clean/features/announcements/domain/usecases/get_announcements.dart';

void main() {
  final item = Announcement(
    id: '1',
    title: 'Ujian',
    body: 'Ujian dimulai pukul 08.00.',
    updatedAt: DateTime(2026, 10, 15),
  );

  test('GetAnnouncements returns entities from a fake repository', () async {
    final repository = FakeAnnouncementRepository(items: [item]);
    final result = await GetAnnouncements(repository).call();

    expect(result.failure, isNull);
    expect(result.announcements, [item]);
  });

  test('GetAnnouncement returns a failure when the item is missing', () async {
    final repository = FakeAnnouncementRepository(items: [item]);
    final result = await GetAnnouncement(repository).call('missing');

    expect(result.announcement, isNull);
    expect(result.failure, isA<LocalFailure>());
  });

  test('formatDate and routeFromMessage are pure helpers', () {
    expect(formatDate(DateTime(2026, 1, 5)), '05/01/2026');
    expect(routeFromMessage({'route': 'pengumuman/1'}), '/pengumuman/1');
    expect(routeFromMessage(const <String, dynamic>{}), '/');
  });
}

class FakeAnnouncementRepository implements AnnouncementRepository {
  FakeAnnouncementRepository({required this.items});

  final List<Announcement> items;

  @override
  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  ) async {
    for (final item in items) {
      if (item.id == id) return (announcement: item, failure: null);
    }
    return (
      announcement: null,
      failure: const LocalFailure('Pengumuman tidak ditemukan.'),
    );
  }

  @override
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements() async => (announcements: items, failure: null);
}
