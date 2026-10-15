import '../../../../core/failures.dart';
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements();

  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  );
}
