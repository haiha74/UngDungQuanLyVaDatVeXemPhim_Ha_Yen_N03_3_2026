import 'admin_dashboard_page.dart';

class AdminShowtimesPage extends AdminCollectionPage {
  const AdminShowtimesPage({super.key})
      : super(
          collection: 'showtimes',
          title: 'Showtimes',
          fields: const [
            AdminField.dropdown('movieId', label: 'Movie', sourceCollection: 'movies', sourceLabelField: 'title'),
            AdminField.dropdown('roomId', label: 'Room', sourceCollection: 'rooms', sourceLabelField: 'roomName'),
            AdminField.dateTime('startTime', required: true),
            AdminField.dateTime('endTime', required: true),
            AdminField.text('basePrice', number: true, required: true),
            AdminField.text('status', required: true),
          ],
          references: const {
            'movieId': AdminReference(collection: 'movies', labelField: 'title'),
            'roomId': AdminReference(collection: 'rooms', labelField: 'roomName'),
          },
          statusField: 'status',
        );
}
