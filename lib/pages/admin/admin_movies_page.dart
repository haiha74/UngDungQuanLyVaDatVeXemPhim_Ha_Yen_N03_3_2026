import 'admin_dashboard_page.dart';

class AdminMoviesPage extends AdminCollectionPage {
  const AdminMoviesPage({super.key})
      : super(
          collection: 'movies',
          title: 'Movies',
          fields: const [
            AdminField.text('title', required: true),
            AdminField.text('description'),
            AdminField.text('runtime', number: true, required: true),
            AdminField.text('posterUrl', required: true),
            AdminField.text('trailerUrl'),
            AdminField.text('status', required: true),
            AdminField.date('releaseDate'),
          ],
          statusField: 'status',
        );
}
