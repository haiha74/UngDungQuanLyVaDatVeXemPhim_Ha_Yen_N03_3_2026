import 'admin_dashboard_page.dart';

class AdminMoviesPage extends AdminCollectionPage {
  const AdminMoviesPage({super.key})
      : super(
          collection: 'movies',
          title: 'Movies',
          titleField: 'title',
          fields: const [
            AdminField.text('title', required: true),
            AdminField.text('description'),
            AdminField.text('runtime', number: true, required: true),
            AdminField.text('posterUrl', required: true),
            AdminField.text('trailerUrl'),
            AdminField.options(
              'status',
              required: true,
              options: ['NOW_SHOWING', 'COMING_SOON'],
            ),
            AdminField.date('releaseDate'),
          ],
          statusField: 'status',
        );
}
